# 2 Yocto 项目术语

[Build Directory](#Build Directory)

该术语指 OpenEmbedded 构建系统用于构建的区域。该区域在源代码目录（即 oe-init-build-env）中的设置环境脚本时创建。TOPDIR 变量指向[构建目录](#Build Directory)。

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