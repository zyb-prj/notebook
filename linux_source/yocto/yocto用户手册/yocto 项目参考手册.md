# 2 Yocto 项目术语

## Poky

Poky 的发音是 Pock-ee，是一种参考嵌入式发行版和参考测试配置。Poky 提供以下功能：

- 用于说明如何定制发行版的基础功能发行版。


- 测试 Yocto 项目组件的一种方法（即 Poky 用于验证 Yocto 项目）。


- 下载 Yocto 项目的工具。

Poky 并非产品级发行版。相反，它是定制的一个良好起点。

备注：Poky 最初是 OpenedHand 开发的一个开源项目。OpenedHand 在现有 OpenEmbedded 构建系统的基础上开发了 Poky，目的是为嵌入式 Linux 创建一个商业上可支持的构建系统。英特尔公司收购 OpenedHand 后，poky 项目成为 Yocto 项目构建系统的基础。

## Build Directory

该术语指 OpenEmbedded 构建系统用于构建的区域。该区域在源代码目录（即 oe-init-build-env）中的设置环境脚本时创建。TOPDIR 变量指向[构建目录](#Build Directory)。

## Source Directory

该术语指的是在创建 poky Git 仓库 git://git.yoctoproject.org/poky 的本地副本或扩展已发布的 poky 压缩包时创建的目录结构。

备注：创建 poky Git 仓库的本地副本是设置源代码目录的推荐方法。

有时，你可能会听到 "poky directory" 这个词来指代这种目录结构。

备注：OpenEmbedded 编译系统不支持包含空格的文件或目录名称。请确保您使用的源代码目录不包含此类名称。

源码目录包含 BitBake、文档、元数据和其他支持 Yocto 项目的文件。因此，你必须在开发系统中安装源码目录，才能使用 Yocto 项目进行开发。

创建 Git 仓库的本地副本时，您可以随意为仓库命名。在大部分文档中，"poky" 都被用作 poky Git 仓库本地副本的顶级文件夹名称。因此，举例来说，克隆 poky Git 仓库后，本地 Git 仓库的顶层文件夹也命名为 "poky"。

虽然不建议使用压缩包解压缩来建立源代码目录，但如果使用了，源代码目录的顶级目录名将来自于 Yocto 项目发布的压缩包。例如，从 https://downloads.yoctoproject.org/releases/yocto/yocto-4.2.999/ 下载并解压 poky 压缩包后，源码目录的根目录就会命名为 poky。

了解解压已发布的压缩包所创建的源代码目录与克隆 git://git.yoctoproject.org/poky 所创建的源代码目录之间的区别非常重要。当你解压一个 tar 包时，你就拥有了一个基于发布时间的精确文件拷贝--一个固定的发布点。你对源代码目录中的本地文件所做的任何改动都是在发布时间之上的，并且只能保留在本地。另一方面，当你克隆 poky Git 仓库时，你就拥有了一个活动的开发仓库，可以访问上游仓库的分支和标签。在这种情况下，你对本地源代码目录所做的任何本地更改，都可以在以后应用到上游 poky Git 仓库的活动开发分支中。

有关 Git 仓库、分支和标记相关概念的更多信息，请参阅《Yocto 项目概念手册》中的 "[仓库、标记和分支](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/yocto%20%E9%A1%B9%E7%9B%AE%E6%A6%82%E5%BF%B5%E6%89%8B%E5%86%8C.md#351-%E4%BB%93%E5%BA%93%E6%A0%87%E7%AD%BE%E5%92%8C%E5%88%86%E6%94%AF)" 部分。

# 5_Classes

## 5-67_kernel-yocto

[kernel-yocto](#5-67_kernel-yocto) 类提供了从 linux-yocto 风格内核源代码库构建的通用功能。





# 6_Tasks

### 6-4-6_do_kernel_menuconfig

由用户调用，用于操作用于构建 linux-yocto 配方的 .config 文件。该任务会启动 Linux 内核配置工具，然后你可以用它来修改内核配置。

备注：您也可以通过命令行调用该工具，方法如下：

```bash
$ bitbake linux-yocto -c menuconfig
```

### 6-4-9_do_savedefconfig

当用户调用时，会创建一个 defconfig 文件，用来代替默认的 defconfig。保存的 defconfig 文件包含默认 defconfig 与用户使用其他方法（如 [do_kernel_menuconfig](#6-4-6_do_kernel_menuconfig) 任务）所作更改之间的差异。您可以使用以下命令调用该任务：

有关该配置工具的更多信息，请参阅《Yocto Project Linux 内核开发手册》中的 "[使用 menuconfig](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/kernel%20%E5%BC%80%E5%8F%91%E6%89%8B%E5%86%8C.md#2-6-1_%E4%BD%BF%E7%94%A8-menuconfig)" 部分。



# 12 变量词汇表

## TOPDIR

请参阅 BitBake 手册中的 [TOPDIR](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/bitbake%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C.md#topdir)。

## Metadata

Yocto 项目的一个关键要素是用于构建 Linux 发行版的元数据（Metadata），它包含在 OpenEmbedded 编译系统在构建映像时解析的文件中。一般来说，元数据包括配方、配置文件和其他与构建指令本身相关的信息，以及用于控制构建内容和构建效果的数据。元数据还包括用于说明所使用软件版本的命令和数据、这些命令和数据的来源，以及对软件本身的更改或添加（补丁或辅助文件），这些更改或添加用于修复错误或定制软件，以便在特定情况下使用。OpenEmbedded-Core 是一套重要的验证元数据。

在内核（"内核元数据"）方面，该术语指的是 yocto-kernel-cache Git 仓库中包含的内核配置片段和功能。

## MACHINE

指定构建映像的目标设备。您可以在构建目录中的 local.conf 文件中定义 MACHINE。默认情况下，MACHINE 设置为 "qemux86"，即使用 QEMU 仿真的基于 x86 架构的机器：

```bash
MACHINE ?= "qemux86"
```

该变量与同名的机器配置文件相对应，通过该文件可以设置特定机器的配置。因此，当 [MACHINE](#MACHINE) 设置为 "qemux86" 时，相应的 qemux86.conf 机器配置文件就会出现在[源目录](https://docs.yoctoproject.org/ref-manual/terms.html#term-Source-Directory)的 meta/conf/machine 中。

Yocto 项目支持的已发布机器列表如下：

```bash
MACHINE ?= "qemuarm"
MACHINE ?= "qemuarm64"
MACHINE ?= "qemumips"
MACHINE ?= "qemumips64"
MACHINE ?= "qemuppc"
MACHINE ?= "qemux86"
MACHINE ?= "qemux86-64"
MACHINE ?= "genericx86"
MACHINE ?= "genericx86-64"
MACHINE ?= "beaglebone"
MACHINE ?= "edgerouter"
```

最后五个是 Yocto Project 参考硬件板，在 meta-yocto-bsp 层中提供。

备注：在配置中添加额外的电路板支持包 (BSP) 层可为 [MACHINE](#MACHINE) 增加新的可能设置。

## SRC_URI

有关该变量的初始描述，请参阅 BitBake 手册：[SRC_URI](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/bitbake%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C.md#src_uri)。

OpenEmbedded 和 Yocto 项目增加了以下功能。

有标准选项和特定配方选项。下面是标准选项：

- apply - 是否应用补丁。默认操作是打补丁。


- striplevel - 应用补丁时要使用的级别。默认级别为 1。


- patchdir - 指定应用补丁的目录。默认值为 ${S}。

以下是从修订控制系统中获取建筑代码的特定选项：

- mindate - 仅当 SRCDATE 等于或大于 mindate 时才应用补丁。


- maxdate - 仅当 SRCDATE 不晚于 maxdate 时才应用补丁。


- minrev - 仅当 SRCREV 等于或大于 minrev 时才应用修补程序。


- maxrev - 仅当 SRCREV 不晚于 maxrev 时才应用修补程序。


- rev - 仅当 SRCREV 等于 rev 时才打补丁。


- notrev - 仅当 SRCREV 不等于 rev 时才打补丁。

备注：如果希望构建系统从附加文件中获取通过 [SRC_URI](#SRC_URI) 语句指定的文件，则必须确保在附加文件中使用 [FILESEXTRAPATHS](#FILESEXTRAPATHS) 变量来扩展 FILESPATH 变量。

## MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS

建议安装的特定机器软件包列表，作为正在构建的映像的一部分。构建过程并不依赖于这些软件包的存在。不过，由于这是一个 "机器必备" 变量，因此软件包列表对于机器启动是必不可少的。此变量会影响基于 packagegroup-core-boot 的镜像，包括 core-image-minimal 镜像。

该变量与 [MACHINE_ESSENTIAL_EXTRA_RDEPENDS](#MACHINE_ESSENTIAL_EXTRA_RDEPENDS) 变量类似，但不同的是，正在联编的映像并不依赖于该变量的软件包列表。换句话说，如果找不到该列表中的软件包，映像仍将继续联编。通常情况下，该变量用于处理重要的内核模块，这些模块的功能可能被选择内置到内核中，而不是作为模块，在这种情况下，将不会生成软件包。

举个例子，你有一个自定义内核，需要特定的触摸屏驱动程序才能使用机器。不过，根据内核配置的不同，该驱动程序可以作为模块或内核内置。如果将驱动程序作为模块内置，则需要安装。但是，当驱动程序内置于内核中时，你仍然希望它能成功构建。这个变量设定了一种 "推荐" 关系，这样在后一种情况下，编译就不会因为缺少软件包而失败。为了实现这一目标，假设模块的软件包名为 kernel-module-ab123，你可以在机器的 .conf 配置文件中使用以下内容：

```bash
MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS += "kernel-module-ab123"
```

备注：在本例中，kernel-module-ab123 配方需要明确设置其 PACKAGES 变量，以确保 BitBake 不会使用 kernel 配方的 PACKAGES_DYNAMIC 变量来满足依赖关系。

## PACKAGES

配方创建的软件包列表。默认值如下：

```bash
${PN}-src ${PN}-dbg ${PN}-staticdev ${PN}-dev ${PN}-doc ${PN}-locale ${PACKAGE_BEFORE_PN} ${PN}
```

在打包过程中，do_package 任务会遍历 PACKAGES，并使用与每个软件包对应的 FILES 变量将文件分配给软件包。如果一个文件与 PACKAGES 中多个软件包的 FILES 变量匹配，它将被分配到最早（最左）的软件包。

## BBLAYERS

列出要在构建过程中启用的图层。该变量在[构建目录](Build Directory)中的 bblayers.conf 配置文件中定义。下面是一个示例：

```bash
BBLAYERS = " \
    /home/scottrif/poky/meta \
    /home/scottrif/poky/meta-poky \
    /home/scottrif/poky/meta-yocto-bsp \
    /home/scottrif/poky/meta-mykernel \
    "
```

该示例启用了四个层，其中一个是用户自定义层，名为 meta-mykernel。

## FILESPATH

OpenEmbedded 构建系统搜索补丁和文件时使用的默认目录集。

在编译过程中，BitBake 会按指定顺序搜索 [FILESPATH](#FILESPATH) 中的每个目录，以查找配方 SRC_URI 语句中每个 file:// URI 指定的文件和补丁。

## FILESEXTRAPATHS

扩展 OpenEmbedded 构建系统在处理配方和附加文件时查找文件和补丁时使用的搜索路径。BitBake 处理配方时使用的默认目录最初由 FILESPATH 变量定义。你可以使用 FILESEXTRAPATHS 来扩展 FILESPATH 变量。

## KCONFIG_MODE

与 [kernel-yocto](#5-67_kernel-yocto) 类一起使用时，指定内核配置值，用于未在提供的 defconfig 文件中指定的选项。有效选项包括：

```bash
KCONFIG_MODE = "alldefconfig"
KCONFIG_MODE = "allnoconfig"
```

在 alldefconfig 模式下，未明确指定的选项将分配给 Kconfig 默认值。在 allnoconfig 模式下，未明确指定的选项将在内核配置中禁用。

如果未设置 [KCONFIG_MODE](#KCONFIG_MODE)，行为将取决于 defconfig 文件的来源。"in-tree"  defconfig 文件将在 alldefconfig 模式下处理，而通过元层放置在 ${WORKDIR} 中的 defconfig 文件将在 allnoconfig 模式下处理。

可通过 KBUILD_DEFCONFIG 变量选择 "in-tree" 的 defconfig 文件。[KCONFIG_MODE](#KCONFIG_MODE) 不需要明确设置。

从正在运行的 Linux 内核中复制 .config 文件，将其重命名为 defconfig，然后通过元层将其放入 Linux 内核 ${WORKDIR} 中，即可生成与 allnoconfig 模式兼容的 defconfig 文件。无需明确设置 [KCONFIG_MODE](#KCONFIG_MODE)。

可以使用 [do_savedefconfig](#6-4-9_do_savedefconfig) 任务生成与 alldefconfig 模式兼容的 defconfig 文件，并通过元层放入 Linux 内核 ${WORKDIR}。明确设置 [KCONFIG_MODE](#KCONFIG_MODE)：

```bash
KCONFIG_MODE = "alldefconfig"
```

## PREFERRED_VERSION

如果配方有多个版本，该变量将决定优先选择哪个版本。您必须在该变量后缀上您要选择的 PN（下面第一个例子中为 python），并相应指定 PV（例子中为 3.4.0）。

[PREFERRED_VERSION](#PREFERRED_VERSION) 变量通过 "%" 字符支持有限的通配符使用。您可以使用该字符匹配任意数量的字符，这在指定包含可能更改的长版本号的版本时非常有用。下面是两个例子：

```bash
PREFERRED_VERSION_python = "3.4.0"
PREFERRED_VERSION_linux-yocto = "5.0%"
```

备注："%" 字符的使用受到限制，只能在字符串的末尾使用。不能在字符串的其他位置使用通配符。

指定的版本与 PV 匹配，而 [PV](#PV) 不一定与配方文件名中的版本部分匹配。例如，考虑两个配方 foo_1.2.bb 和 fo_git.bb，其中 foo_git.bb 包含以下赋值：

```bash
PV = "1.1+git${SRCPV}"
```

在这种情况下，选择 foo_git.bb 的正确方法是使用如下赋值：

```bash
PREFERRED_VERSION_foo = "1.1+git%"
```

将前面的例子与下面的错误例子进行比较，后者是行不通的：

```bash
PREFERRED_VERSION_foo = "git"
```

有时，配置文件会以难以更改的方式设置 [PREFERRED_VERSION](#PREFERRED_VERSION) 变量。你可以使用 OVERRIDES 来设置特定机器的覆盖值。下面是一个例子：

## OVERRIDES

以冒号分隔的当前适用的覆盖列表。重写是 BitBake 的一种机制，允许在解析结束时选择性地重写变量。[OVERRIDES](#OVERRIDES) 中的重载集代表构建过程中的 "状态"，包括当前正在构建的配方、构建配方的机器等。

例如，如果字符串 "an-override" 作为元素出现在 [OVERRIDES](#OVERRIDES) 中以冒号分隔的列表中，那么下面的赋值将在解析结束时以 "overridden" 值覆盖 FOO：

```bash
FOO:an-override = "overridden"
```

有关覆盖机制的更多信息，请参阅《BitBake 用户手册》中的 "条件语法（覆盖" 部分。

## P

食谱名称和版本。[P](#P) 由以下部分组成：

```bash
${PN}-${PV}
```

## PN

根据上下文的不同，该变量有两种不同的功能：配方名称或生成的软件包名称。

[PN](#PN) 指的是 OpenEmbedded 构建系统用于创建软件包的输入文件中的配方名称。该名称通常是从配方文件名中提取的。例如，如果配方名为 expat_2.0.1.bb，那么 PN 的默认值就是 "expat"。

该变量指的是 OpenEmbedded 构建系统创建或生成的文件中的软件包名称。

如果适用，[PN](#PN) 变量还包含任何特殊的后缀或前缀。例如，使用 bash 为本地机器构建软件包时，[PN](#PN) 为 bash-native。使用 bash 为目标机和 Multilib 构建软件包时，[PN](#PN) 分别为 bash 和 lib64-bash。

## PV

配方的版本。版本通常从菜谱文件名中提取。例如，如果配方名为 expat_2.0.1.bb，那么 PV 的默认值就是 "2.0.1"。除非从源代码库（如 Git 或 Subversion）构建不稳定（即开发）版本，否则通常不会在配方中覆盖 [PV](#PV) 值。

[PV](#PV) 是 [PKGV](#PKGV) 变量的默认值。

## PKGV

配方构建的软件包的版本。默认情况下，[PKGV](#PKGV) 设置为 [PV](#PV)。