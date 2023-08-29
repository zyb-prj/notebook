





# 1 引言

## 1.1 概述

无论你打算如何使用 Yocto 项目，你都有可能使用 Linux 内核。本手册介绍了如何设置你的构建主机以支持内核开发，介绍了内核开发过程，提供了有关 Yocto Linux 内核 [Metadata](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/yocto%20%E9%A1%B9%E7%9B%AE%E5%8F%82%E8%80%83%E6%89%8B%E5%86%8C.md#metadata) 的背景信息，描述了你可以使用内核工具执行的常见任务，向你展示了如何使用 Yocto 项目内的内核元数据，并深入介绍了 Yocto 项目团队如何开发和维护 Yocto Linux 内核 Git 仓库和元数据。

## 1.2 内核修改工作流程

内核修改涉及对 Yocto 项目内核的更改，包括更改配置选项和添加新的内核配方。配置更改可以以配置片段的形式添加，而配方修改则通过你创建的内核层中的内核配方-内核区域进行。

本节简要介绍 Yocto 项目内核修改工作流程。插图和附带清单提供了一般信息和进一步信息的参考。

工作流程如下图 1-1 所示：

![1-1_yocto下Linux内核修改工作流程图](https://zyb-note-pic.oss-cn-chengdu.aliyuncs.com/linux-source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/Linux%E5%86%85%E6%A0%B8%E5%BC%80%E5%8F%91%E6%89%8B%E5%86%8C/1-1_yocto%E4%B8%8BLinux%E5%86%85%E6%A0%B8%E4%BF%AE%E6%94%B9%E5%B7%A5%E4%BD%9C%E6%B5%81%E7%A8%8B%E5%9B%BE.png?OSSAccessKeyId=LTAI5tREkNKGRcMiPdgNQUye&Expires=10000000001693276000&Signature=kie30quHKhd9QvutTddII%2BR3RJY%3D)

### 1st 设置你的主机开发系统以支持使用 Yocto 项目的开发

请参阅《Yocto 项目开发任务手册》中的 "[设置以使用 Yocto 项目"部分](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/yocto%20%E9%A1%B9%E7%9B%AE%E5%BC%80%E5%8F%91%E6%89%8B%E5%86%8C.md#2-%E8%AE%BE%E7%BD%AE%E4%BD%BF%E7%94%A8-yocto-%E9%A1%B9%E7%9B%AE)，了解如何让构建主机为使用 Yocto 项目做好准备。

### 2nd 为内核开发设置主机开发系统

建议使用 devtool 进行内核开发。或者，你也可以使用 Yocto 项目的传统内核开发方法。无论哪种方法，你都需要采取一些步骤来准备好开发环境。

使用 devtool 需要有一个完整的镜像。有关详细信息，请参阅 "[准备使用 devtool 进行开发](#2.1.1 准备使用 devtool 进行开发)"部分。

使用传统内核开发方法需要在本地 Git 代码库中拥有独立的内核源代码。更多信息，请参阅 "[为传统内核开发做好准备](#2.1.2 为传统内核开发做好准备)"部分。

### 3rd 修改内核源代码

修改内核并不总是意味着直接修改源文件。不过，如果您必须这样做，您可以在使用 devtool 时修改 Yocto 的[构建目录](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/yocto%20%E9%A1%B9%E7%9B%AE%E5%8F%82%E8%80%83%E6%89%8B%E5%86%8C.md#build-directory)中的文件。更多信息，请参阅 "[使用 devtool 给内核打补丁](#2.4 使用 devtool 修补内核)"部分。

如果使用传统的内核开发方式，则需要编辑内核本地 Git 代码库中的源文件。如需了解更多信息，请参阅 "[使用传统内核开发为内核打补丁](#2.5 使用传统内核开发方法为内核打补丁)"部分。

### 4th 根据需要更改内核配置

如果您需要更改内核配置，可以[使用 menuconfig](#2.6.1 使用 menuconfig)，它允许您以交互方式开发和测试对内核进行的配置更196319

改。保存使用 menuconfig 所做的更改会更新内核的 .config 文件。

备注：尽量抵制直接编辑现有 .config 文件的诱惑，该文件位于用于构建的源代码的构建目录中。这样做可能会在 OpenEmbedded 构建系统重新生成配置文件时产生意想不到的结果。

一旦对使用 menuconfig 所做的配置更改感到满意并已保存，就可以直接将生成的 .config 文件与现有的原始文件进行比较，并将这些更改收集到配置片段文件中，以便在内核的 .bbappend 文件中引用。

此外，如果您在 BSP 层工作，需要修改 BSP 内核的配置，可以使用 menuconfig。

### 5th 根据修改内容重建内核映像

重建内核映像会应用你所做的更改。根据您的目标硬件，您可以在实际硬件或 QEMU 上验证您的更改。

本开发者指南的其余部分将介绍内核开发过程中的常用任务、高级元数据用法以及 Yocto Linux 内核维护概念。



# 2 通用任务

本章介绍了使用 Yocto Project Linux 内核时的几种常见任务。这些任务包括：为内核开发准备主机开发系统、准备层、修改现有配方、修补内核、配置内核、迭代开发、使用自己的源代码，以及整合树外模块。

备注：本章介绍的示例适用于 Yocto Project 2.4 及以后的版本。

## 2.1 准备好联编主机以在内核上工作

在进行任何内核开发之前，你需要确保你的构建主机已设置为使用 Yocto 项目。有关如何设置的信息，请参阅《Yocto 项目开发任务手册》中的 "[设置使用 Yocto 项目](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/yocto%20%E9%A1%B9%E7%9B%AE%E5%BC%80%E5%8F%91%E6%89%8B%E5%86%8C.md#2-%E8%AE%BE%E7%BD%AE%E4%BD%BF%E7%94%A8-yocto-%E9%A1%B9%E7%9B%AE)" 部分。准备系统的一部分工作是在系统上创建源代码目录 ([poky](https://www.yoctoproject.org/software-overview/downloads/)) 的本地 Git 仓库。请按照《Yocto 项目开发任务手册》中 "[克隆 poky 仓库](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/yocto%20%E9%A1%B9%E7%9B%AE%E5%BC%80%E5%8F%91%E6%89%8B%E5%86%8C.md#241-%E5%85%8B%E9%9A%86-poky-%E4%BB%93%E5%BA%93)" 一节的步骤设置源代码目录。

备注：请确保您签出了相应的开发分支，或者通过签出特定标签创建了本地分支，以获得所需的 Yocto Project 版本。更多信息，请参阅《Yocto 项目开发任务手册》中的 "[在 Poky 中通过分支签出](https://docs.yoctoproject.org/dev-manual/start.html#checking-out-by-branch-in-poky)" 和 "[在 Poky 中通过标签签出](https://docs.yoctoproject.org/dev-manual/start.html#checking-out-by-tag-in-poky)" 章节。

内核开发最好使用 devtool，而不是传统的内核工作流程方法。本节其余部分将提供这两种情况的信息。

### 2.1.1 准备使用 devtool 进行开发

按照以下步骤准备使用 devtool 更新内核映像。完成此步骤后，您将获得干净的内核映像，并准备好按照 "[使用 devtool 给内核打补丁](#2.4 使用 devtool 为内核打补丁)" 部分所述进行修改：

#### 1st 初始化 BitBake 环境

您需要通过获取构建环境脚本（即 oe-init-build-env）来初始化 BitBake 的构建环境：

```bash
source poky/oe-init-build-env
```

备注：前面的命令假定 [Yocto 项目源代码库](https://docs.yoctoproject.org/overview-manual/development-environment.html#yocto-project-source-repositories)（即 poky）已使用 Git 克隆，且本地仓库名为 "poky"。

#### 2nd 准备 local.conf 文件

默认情况下，[MACHINE](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/%E5%8F%82%E8%80%83%E6%89%8B%E5%86%8C.md#machine) 变量被设置为 "qemux86-64"，如果你是在 64 位模式下为 QEMU 模拟器构建系统，那么这个设置就没问题。但如果不是，则需要在[构建目录](https://docs.yoctoproject.org/ref-manual/terms.html#term-Build-Directory)（即本例中的 poky/build）中的 conf/local.conf 文件中适当设置 [MACHINE](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/%E5%8F%82%E8%80%83%E6%89%8B%E5%86%8C.md#machine) 变量。

此外，由于您正准备处理内核映像，因此需要设置 [MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/%E5%8F%82%E8%80%83%E6%89%8B%E5%86%8C.md#machine_essential_extra_rrecommends) 变量，以包含内核模块。

在本例中，我们希望为 qemux86 构建系统，因此必须将 MACHINE 变量设置为 "qemux86"，并添加 "kernel-modules"。如前所述，我们可以通过追加到 conf/local.conf 来实现这一点：

```bash
MACHINE = "qemux86"
MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS += "kernel-modules"
```

#### 3rd 为补丁创建图层

您需要创建一个层来保存为内核映像创建的补丁。您可以使用 bitbake-layers create-layer 命令，如下所示：

```bash
$ cd poky/build
$ bitbake-layers create-layer ../../meta-mylayer
NOTE: Starting bitbake server...
Add your new layer with 'bitbake-layers add-layer ../../meta-mylayer'
$
```

备注：有关使用普通图层和 BSP 图层的背景信息，请分别参阅 Yocto Project 开发任务手册 中的 "[理解并创建图层](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/yocto%20%E9%A1%B9%E7%9B%AE%E5%BC%80%E5%8F%91%E6%89%8B%E5%86%8C.md#3-%E7%90%86%E8%A7%A3%E5%B9%B6%E5%88%9B%E5%BB%BA%E5%9B%BE%E5%B1%82)" 一节，以及 Yocto Project Board Support [(BSP) 开发者指南](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/bsp%20%E5%BC%80%E5%8F%91%E6%89%8B%E5%86%8C.md) 中的 "[BSP 图层](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/bsp%20%E5%BC%80%E5%8F%91%E6%89%8B%E5%86%8C.md#1-bsp-%E5%9B%BE%E5%B1%82)" 一节。关于如何使用 bitbake-layers create-layer 命令快速创建图层，请参阅《Yocto 工程开发任务手册》中的 "[使用 bitbake-layers 脚本创建普通图层](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/yocto%20%E9%A1%B9%E7%9B%AE%E5%BC%80%E5%8F%91%E6%89%8B%E5%86%8C.md#38-%E4%BD%BF%E7%94%A8-bitbake-layers-%E8%84%9A%E6%9C%AC%E5%88%9B%E5%BB%BA%E5%B8%B8%E8%A7%84%E5%9B%BE%E5%B1%82)" 一节。

#### 4th 向 BitBake 构建环境通报您的图层

按照创建图层时的指示，您需要将图层添加到 bblayers.conf 文件中的 [BBLAYERS](#BBLAYERS) 变量中，如下所示：

```bash
$ cd poky/build
$ bitbake-layers add-layer ../../meta-mylayer
NOTE: Starting bitbake server...
$
```

#### 5th 编译干净的镜像

准备内核工作的最后一步是使用 bitbake 构建初始镜像：

```bash
$ bitbake core-image-minimal
Parsing recipes: 100% |##########################################| Time: 0:00:05
Parsing of 830 .bb files complete (0 cached, 830 parsed). 1299 targets, 47 skipped, 0 masked, 0 errors.
WARNING: No packages to add, building image core-image-minimal unmodified
Loading cache: 100% |############################################| Time: 0:00:00
Loaded 1299 entries from dependency cache.
NOTE: Resolving any missing task queue dependencies
Initializing tasks: 100% |#######################################| Time: 0:00:07
Checking sstate mirror object availability: 100% |###############| Time: 0:00:00
NOTE: Executing SetScene Tasks
NOTE: Executing RunQueue Tasks
NOTE: Tasks Summary: Attempted 2866 tasks of which 2604 didn't need to be rerun and all succeeded.
```

如果是为实际硬件而非仿真而构建，可以将映像闪存到 /dev/sdd 上的 USB 记忆棒中，然后启动设备。有关使用 Minnowboard 的示例，请参阅 [TipsAndTricks/KernelDevelopmentWithEsdk Wiki](https://wiki.yoctoproject.org/wiki/TipsAndTricks/KernelDevelopmentWithEsdki) 页面。

至此，你就可以开始修改内核了。更多示例，请参阅 "[使用 devtool 修补内核](#2.4 使用 devtool 为内核打补丁)" 部分。

### 2.1.2 为传统内核开发做好准备

准备使用 Yocto 项目进行传统内核开发的许多步骤与上一节所述相同。不过，你需要建立内核源代码的本地副本，因为你将编辑这些文件。

按照以下步骤，准备使用 Yocto 项目的传统内核开发流程更新内核映像。完成此步骤后，您就可以按照 "[使用传统内核开发流程为内核打补丁](#2.5 使用传统内核开发方法为内核打补丁)" 部分所述，对内核源代码进行修改：

#### 1st 初始化 BitBake 环境

在使用 BitBake 进行任何操作之前，你需要通过获取构建环境脚本（即 [oe-init-build-env](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/yocto%20%E9%A1%B9%E7%9B%AE%E5%BC%80%E5%8F%91%E6%89%8B%E5%86%8C.md#4110-oe-init-build-env)）来初始化 BitBake 的构建环境。另外，在本例中，请确保你为 poky 签出的本地分支是 Yocto 项目的 Mickledore 分支。如果您需要签出 Mickledore 分支，请参阅《Yocto 项目开发任务手册》中的 "在 Poky 中按分支签出 "部分：

## 2.2 创建和准备图层

## 2.3 修改现有配方

### 2.3.1 创建附加文件

### 2.3.2 应用补丁

### 2.3.3 更改配置

### 2.3.4 使用 "树内 "defconfig 文件

## 2.4 使用 devtool 为内核打补丁

本步骤将向您展示如何使用 devtool 给内核打补丁。

备注：在尝试此步骤之前，请确保您已执行了 "[准备使用 devtool 进行开发](#2.1.1 准备使用 devtool 进行开发)" 一节中所述的更新内核的准备步骤。

内核补丁包括更改或添加现有内核的配置，更改或添加支持特定硬件功能所需的内核配方，甚至更改源代码本身。

本例通过在内核 calibrate.c 源代码文件中的 printk 语句，在启动时添加一些 QEMU 模拟器控制台输出，从而创建了一个简单的补丁。打上补丁并启动修改后的映像后，增加的信息就会出现在模拟器的控制台上。本例是 "[准备使用 devtool 进行开发](#2.1.1 准备使用 devtool 进行开发)" 一节中设置过程的延续。

### 2.4.1 查看内核源文件

首先，你必须使用 devtool 在其工作区签出内核源代码。

备注：有关详细信息，请参阅 "[准备使用 devtool 进行开发](#2.1.1 准备使用 devtool 进行开发)" 部分中的这一步骤。

使用以下 devtool 命令查看代码：

```bash
devtool modify linux-yocto
```

备注：在结账操作过程中，有一个错误可能会导致以下错误，您可以放心地忽略这些信息。源代码已正确签出。

```bash
ERROR: Taskhash mismatch 2c793438c2d9f8c3681fd5f7bc819efa versus
       be3a89ce7c47178880ba7bf6293d7404 for
       /path/to/esdk/layers/poky/meta/recipes-kernel/linux/linux-yocto_4.10.bb.do_unpack
```

### 2.4.2 编辑源码并执行后续相关操作

#### 1st 切换工作目录

在上一步中，输出结果指出了可以找到源文件的位置（例如 poky_sdk/workspace/sources/linux-yocto）。在对 calibrate.c 文件进行编辑之前，请切换到内核源代码所在的位置：

```bash
cd poky_sdk/workspace/sources/linux-yocto
```

#### 2nd 编辑源文件

编辑 init/calibrate.c 文件，作出以下修改：

```c
void calibrate_delay(void)
{
    unsigned long lpj;
    static bool printed;
    int this_cpu = smp_processor_id();

    printk("*************************************\n");
    printk("*                                   *\n");
    printk("*        HELLO YOCTO KERNEL         *\n");
    printk("*                                   *\n");
    printk("*************************************\n");

    if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
          .
          .
          .
```

#### 3rd 构建更新的内核源代码

要构建更新的内核源代码，请使用 devtool：

```bash
devtool build linux-yocto
```

#### 4th 使用新内核创建映像

使用 devtool build-image 命令创建包含新内核的新镜像：

```bash
cd ~
devtool build-image core-image-minimal
```

备注：如果您最初创建的映像是 Wic 文件，您可以使用另一种方法创建带有更新内核的新映像。有关示例，请参阅 [TipsAndTricks/KernelDevelopmentWithEsdk Wiki](https://wiki.yoctoproject.org/wiki/TipsAndTricks/KernelDevelopmentWithEsdk ) 页面中的步骤。

#### 5th 测试新镜像

启动映像：使用此命令在 QEMU 模拟器中启动修改后的映像：

```bash
runqemu qemux86
```

验证更改：使用 root（无密码）登录计算机，然后使用以下 shell 命令滚动控制台的启动输出：

```bash
dmesg | less
```

当你向下滚动控制台窗口时，应该能看到 printk 语句的部分输出结果。

#### 6th 阶段并提交更改

将工作目录更改为修改 calibrate.c 文件的位置，然后使用这些 Git 命令来分阶段提交修改：

```bash
cd poky_sdk/workspace/sources/linux-yocto
git status
git add init/calibrate.c
git commit -m "calibrate: Add printk example"
```

#### 7th 导出补丁并创建附加文件

要将提交导出为补丁并创建 .bbappend 文件，请使用以下命令。本示例使用先前建立的名为 meta-mylayer 的层：

```bash
devtool finish linux-yocto ~/meta-mylayer
```

备注：有关设置该层的信息，请参见 ["准备使用 devtool 进行开发" 部分的步骤 3](#3rd 为补丁创建图层)。

命令完成后，补丁和 .bbappend 文件就会出现在 ~/meta-mylayer/recipes-kernel/linux 目录中。

#### 8th 使用修改后的内核构建映像

现在就可以构建包含内核补丁的镜像了。在为运行 BitBake 而设置的终端中，从构建目录执行以下命令：

```bash
cd poky/build
bitbake core-image-minimal
```

## 2.5 使用传统内核开发方法为内核打补丁

## 2.6 配置内核

### 2.6.1 使用 menuconfig

### 2.6.2 创建 defconfig 文件

### 2.6.3 创建配置片段

### 2.6.4 验证配置

### 2.6.5 微调内核配置文件

## 2.7 扩展变量

## 2.8 处理 "脏 "内核版本字符串

## 2.9 使用自己的源代码

## 2.10 使用树外模块

### 2.10.1 在目标上构建树外模块

### 2.10.2 整合树外模块

## 2.11 检查更改和提交

### 2.11.1 内核中有哪些改动？

### 2.11.2 显示特定特性或分支变更

## 2.12 添加配方空间内核特征

# 3 使用高级元数据（yocto-kernel-cache）

## 3.1 概述

## 3.2 在配方中使用内核元数据

## 3.3 内核元数据语法

### 3.3.1 配置

### 3.3.2 补丁

### 3.3.3 特征

### 3.3.4 内核类型

### 3.3.5 BSP 描述

#### 3.3.5.1 描述概述

#### 3.3.5.2 示例

## 3.4 内核元数据位置

### 3.4.1 配方空间元数据

### 3.4.2 配方空间之外的元数据

## 3.5 整理源代码

### 3.5.1 封装补丁

### 3.5.2 机器分支

### 3.5.3 特征分支

## 3.6 SCC 描述文件参考

# 4 高级内核概念

## 4.1 Yocto 项目内核开发与维护

## 4.2 Yocto Linux 内核架构和分支策略

## 4.3 内核构建文件层次结构

## 4.4 确定内核配置审核阶段的硬件和非硬件特性

# 5 内核维护

## 5.1 构建内核树

## 5.2 构建策略

# 6 内核开发常见问题

## 6.1 常见问题和解决方案

### 6.1.1 如何使用自己的 Linux 内核 .config 文件？

### 6.1.2 如何创建配置片段？

### 6.1.3 如何使用我自己的 Linux 内核源代码？

### 6.1.4 如何在根文件系统上安装/不安装内核映像？

### 6.1.5 如何安装特定的内核模块？

### 6.1.6 如何更改 Linux 内核命令行？
