# 1 概述

## 1.1 简介

从根本上说，BitBake 是一个通用任务执行引擎，它允许 shell 和 Python 任务高效并行运行，同时在复杂的任务间依赖性约束下工作。BitBake 的主要用户之一 OpenEmbedded 利用这一核心，采用面向任务的方法构建嵌入式 Linux 软件栈。

从概念上讲，BitBake 在某些方面与 GNU Make 相似，但也有显著区别：

- BitBake 会根据所提供的元数据执行任务，这些元数据会构建任务。元数据存储在配方（.bb）和相关配方 "附加"（.bbappend）文件、配置（.conf）和底层包含（.inc）文件以及类（.bbclass）文件中。元数据为 BitBake 提供了运行哪些任务的指令，以及这些任务之间的依赖关系。
- BitBake 包含一个 fetcher 库，用于从本地文件、源代码控制系统或网站等不同地方获取源代码。
- 每个待构建单元（如一个软件）的指令被称为 "配方 "文件，其中包含该单元的所有信息（依赖关系、源文件位置、校验和、描述等）。
- BitBake 包含客户端/服务器抽象，可通过命令行使用，也可通过 XML-RPC 作为服务使用，并有多个不同的用户界面。

## 1.2 历史与目标

BitBake 最初是 OpenEmbedded 项目的一部分。它的灵感来自 Gentoo Linux 发行版使用的 Portage 软件包管理系统。2004 年 12 月 7 日，OpenEmbedded 项目团队成员 Chris Larson 将该项目一分为二：

- 通用任务执行器 BitBake
- OpenEmbedded，BitBake 使用的元数据集

如今，BitBake 已成为 OpenEmbedded 项目的主要基础，该项目正被用于构建和维护 Linux 发行版，如 Yocto 项目旗下开发的 Poky Reference Distribution。

在 BitBake 诞生之前，没有其他构建工具能充分满足嵌入式 Linux 发行版的需求。传统桌面 Linux 发行版使用的所有构建系统都缺乏重要功能，而嵌入式领域流行的基于 Buildroot 的临时系统也都不具备可扩展性和可维护性。

BitBake 最初的一些重要目标是：

- 处理交叉编译。


- 处理软件包之间的依赖关系（目标架构上的构建时间、本地架构上的构建时间以及运行时）。


- 支持在给定软件包内运行任意数量的任务，包括但不限于获取上游源代码、解压缩、打补丁、配置等。


- 在构建和目标系统中均不依赖于 Linux 发行版。


- 与体系结构无关。


- 支持多种构建和目标操作系统（如 Cygwin、BSD 等）。


- 自成一体，而不是紧密集成到构建机的根文件系统中。


- 处理目标架构、操作系统、发行版和机器上的条件元数据。


- 易于使用工具提供本地元数据和软件包，以便进行操作。


- 便于使用 BitBake 在多个项目之间协作进行构建。


- 提供一种继承机制，以便在多个软件包之间共享共同的元数据。

随着时间的推移，显然有必要提出一些进一步的要求：

- 处理基本配方的各种变体（如本地、sdk 和 multilib）。


- 将元数据分层，允许各层增强或覆盖其他层。


- 允许将给定的任务输入变量集表示为校验和。根据校验和，允许使用预构建组件加速构建。

BitBake 不仅满足了所有原始要求，还对基本功能进行了扩展，以满足更多要求。灵活性和强大功能一直是优先考虑的因素。BitBake 具有高度可扩展性，支持嵌入 Python 代码和执行任意任务。

## 1.3 概念

BitBake 是一个用 Python 语言编写的程序。在最高层，BitBake 解释元数据，决定需要运行哪些任务，并执行这些任务。与 GNU Make 类似，BitBake 控制软件的构建方式。GNU Make 通过 "makefile "实现控制，而 BitBake 则使用 "配方"。

BitBake 扩展了 GNU Make 等简单工具的功能，允许定义更复杂的任务，如组装整个嵌入式 Linux 发行版。

本节余下部分将介绍几个概念，为了更好地利用 BitBake 的强大功能，我们应该了解这些概念。

### 1.3.1 食谱

BitBake Recipes（文件扩展名为 .bb）是最基本的元数据文件。这些配方文件为 BitBake 提供了以下功能：

- 软件包的描述性信息（作者、主页、许可证等）


- 配方的版本


- 现有依赖项（包括构建和运行时依赖项）


- 源代码的位置和获取方式


- 源代码是否需要任何补丁，在哪里找到它们，以及如何应用它们


- 如何配置和编译源代码


- 如何将生成的工件组装成一个或多个可安装的软件包


- 在目标计算机的哪个位置安装创建的一个或多个软件包

在 BitBake 或任何使用 BitBake 作为构建系统的项目中，扩展名为 .bb 的文件被称为配方。

**备注**：术语 "包 "也常用于描述菜谱。不过，由于同一个词也用于描述项目的打包输出，因此最好使用单一的描述性术语--"配方"。换句话说，一个 "配方 "文件可以生成多个相关但可单独安装的 "软件包"。事实上，这种能力相当普遍。

### 1.3.2 配置文件

以 .conf 扩展名表示的配置文件定义了管理项目构建过程的各种配置变量。这些文件分为几个部分，分别定义了机器配置、发布配置、可能的编译器调整、通用配置和用户配置。主要配置文件是 bitbake.conf 范例文件，它位于 BitBake 源代码树 conf 目录中。

### 1.3.3 类

类文件的扩展名为 .bbclass，其中包含的信息有助于在元数据文件之间共享。BitBake 源代码树中目前有一个名为 base.bbclass 的类元数据文件。您可以在 classes 目录中找到该文件。base.bbclass 类文件很特别，因为它总是自动包含在所有配方和类中。该类包含标准基本任务的定义，如获取、解压缩、配置（默认为空）、编译（运行存在的任何 Makefile）、安装（默认为空）和打包（默认为空）。在项目开发过程中，这些任务通常会被添加的其他类覆盖或扩展。

### 1.3.4 层

层可以将不同类型的定制相互隔离。在处理单个项目时，你可能会发现把所有东西都放在一个层里很有诱惑力，但元数据越模块化，就越容易应对未来的变化。

为了说明如何使用层来保持模块化，请考虑为支持特定目标机而进行的定制。这类定制通常位于一个特殊层，而不是一般层，称为板卡支持包（BSP）层。此外，机器定制应与支持新图形用户界面环境的配方和元数据等隔离开来。这种情况下就会产生两个层：一个是机器配置层，另一个是图形用户界面环境层。但必须明白的是，BSP 层仍可在 GUI 环境层中对配方进行特定于机器的添加，而不会让这些特定于机器的更改污染 GUI 层本身。您可以通过 BitBake 附加 (.bbappend)文件的配方来实现这一点。

### 1.3.5 附加文件

附加文件是扩展名为 .bbappend 的文件，可扩展或覆盖现有配方文件中的信息。

BitBake 希望每个附加文件都有一个相应的配方文件。此外，附加文件和相应的配方文件必须使用相同的根文件名。文件名只能在使用的文件类型后缀上有所不同（例如，formfactor_0.0.bb 和 formfactor_0.0.bbappend）。

附加文件中的信息会扩展或覆盖底层同名配方文件中的信息。

为附加文件命名时，可以使用"%"通配符来匹配配方名称。例如，假设有一个附加文件，其名称如下：

```sh
busybox_1.21.%.bbappend
```

该附加文件将匹配任何 busybox_1.21.x.bb 版本的配方。因此，该附加文件将匹配以下配方名称：

```sh
busybox_1.21.1.bb
busybox_1.21.2.bb
busybox_1.21.3.bb
```

**备注**："%" 字符的使用受到限制，只能直接在附加文件名的 .bbappend 部分前面使用。不能在文件名的其他位置使用通配符。

如果 busybox 配方更新为 busybox_1.3.0.bb，追加文件的名称就不会匹配。但是，如果将附加文件命名为 busybox_1.%.bbappend，就会匹配。

在最常见的情况下，您可以将附加文件命名为 busybox_%.bbappend，这样就完全不受版本影响了。

## 1.4 获取 BitBake

您可以通过几种不同的方式获取 BitBake：

- **克隆 BitBake**：使用 Git 克隆 BitBake 源代码库是获取 BitBake 的推荐方法。克隆源代码库可以轻松获得错误修复，并访问稳定分支和主分支。克隆 BitBake 后，应使用最新的稳定分支进行开发，因为主分支用于 BitBake 开发，可能包含稳定性较差的更改。

    你通常需要一个与你正在使用的元数据相匹配的 BitBake 版本。元数据通常向后兼容，但不向前兼容。

    下面是一个克隆 BitBake 仓库的例子：

    ```sh
    git clone git://git.openembedded.org/bitbake
    ```

    该命令将 BitBake Git 仓库克隆到一个名为 bitbake 的目录中。或者，如果你想把新目录命名为 bitbake 以外的名字，也可以在 git clone 命令后指定一个目录。下面是一个命名为 bbdev 的例子：

    ```sh
    git clone git://git.openembedded.org/bitbake bbdev 
    ```

- **使用发行版软件包管理系统安装**：不建议使用这种方法，因为在大多数情况下，发行版提供的 BitBake 版本要比 BitBake 软件源快照晚几个版本。

- **获取 BitBake 的快照**：从源代码库下载 BitBake 的快照，即可访问 BitBake 的已知分支或版本。

    **备注**：如前所述，克隆 Git 仓库是获取 BitBake 的首选方法。当补丁添加到稳定分支时，克隆版本库更容易更新。

    - 下面的示例下载了 BitBake 1.17.0 版本的快照：

        ```sh
        wget https://git.openembedded.org/bitbake/snapshot/bitbake-1.17.0.tar.gz
        ```

    - 使用 tar 工具提取 tar 包后，就会得到一个名为 bitbake-1.17.0 的目录：

        ```sh
        tar zxpvf bitbake-1.17.0.tar.gz
        ```

- **使用构建目录时附带的 BitBake**：获得 BitBake 副本的最后一种可能性是，它已随基于 BitBake 的大型构建系统（如 Poky）一起签出。与手动签出单个层并将它们粘合在一起相比，你可以签出整个构建系统。签出的 BitBake 版本已经与其他组件进行了全面的兼容性测试。有关如何检出基于 BitBake 的特定构建系统的信息，请查阅该构建系统的支持文档。

## 1.5 BitBake 命令

bitbake 命令是 BitBake 工具的主要接口。本节将介绍 BitBake 命令的语法，并提供几个执行示例。

### 1.5.1 使用方法和语法

以下是 BitBake 的用法和语法：

```sh
$ bitbake -h
使用方法: bitbake [options] [recipename/target recipe:do_task ...]

    为一组给定的目标配方（.bb 文件）执行指定任务（默认为 "构建"）。
    假定 cwd 或 BBPATH 中有 conf/bblayers.conf，它将提供层、BBFILES 和其他配置信息。

Options:
  --version             显示程序的版本号并退出
  -h, --help            显示此帮助信息并退出
  -b BUILDFILE, --buildfile=BUILDFILE
                        直接执行特定 .bb 配方中的任务。警告：不处理来自其他配方的任何依赖关系。
  -k, --continue        出错后尽可能继续。当失败的目标和任何依赖于它的东西都无法构建，																							会在停止前尽可能多地构建。
  -f, --force           强制运行指定的目标/任务（废止任何现有印章文件）。
  -c CMD, --cmd=CMD     指定要执行的任务。具体选项取决于元数据。一些例子可能是
												编译或"populate_sysroot"或"listtasks"，可能会提供可用任务列表。
  -C INVALIDATE_STAMP, --clear-stamp=INVALIDATE_STAMP
                        使指定任务的印章失效，例如编译，然后为指定目标运行默认任务。																							运行默认任务。
  -r PREFILE, --read=PREFILE
                        在 bitbake.conf 之前读取指定文件。
  -R POSTFILE, --postread=POSTFILE
                        在 bitbake.conf 之后读取指定文件。
  -v, --verbose         启用 shell 任务跟踪（使用 "set -x"）。同时将 bb.note(...)消息打印到																		stdout（除了写入 ${T}/log.do_&lt;task&gt; 之外写入																									${T}/log.do_&lt;task&gt;）。
  -D, --debug           提高调试级别。 您可以多次指定此项。 -D 将调试级别设置为 1，其中仅																				bb.debug(1, ...) 消息打印到 stdout； -DD 将调试级别设置为 2，同时打印 																	bb.debug(1, ...) 和 bb.debug(2, ...) 消息； 等等。如果没有-D，则不会																	打印任何调试消息。 请注意，-D 仅影响到 stdout 的输出。 无论调试级别如何，																	所有调试消息都会写入 ${T}/log.do_taskname。
  -q, --quiet           向终端输出较少的日志信息数据。可以多次指定。
  -n, --dry-run         不执行，只是走过场。
  -S SIGNATURE_HANDLER, --dump-signatures=SIGNATURE_HANDLER
                        转出签名构造信息，不执行任务。SIGNATURE_HANDLER 参数将传递给处理程序。																	两个常用值是 none 和 printdiff。但处理程序可以定义更多或更少的内容。																		none 表示只转储签名，printdiff 表示将转储的签名与缓存的签名进行比较。
  -p, --parse-only      解析 BB 配方后退出。
  -s, --show-versions   显示所有食谱的当前版本和首选版本。
  -e, --environment     显示全局或每个配方环境以及有关设置/更改变量的位置的完整信息。
  -g, --graphviz        以点语法保存指定目标的依赖关系树信息。
  -I EXTRA_ASSUME_PROVIDED, --ignore-deps=EXTRA_ASSUME_PROVIDED
                        假设这些依赖项不存在并且已提供（相当于 ASSUME_PROVIDED）。																							有助于使依赖图更具吸引力。
  -l DEBUG_DOMAINS, --log-domains=DEBUG_DOMAINS
                        显示指定记录域的调试记录。
  -P, --profile         配置命令并保存报告。
  -u UI, --ui=UI        要使用的用户界面（knotty、ncurses、taskexp 或 teamcity - 默认 knotty）。
  --token=XMLRPCTOKEN   Specify the connection token to be used when
                        connecting to a remote server.
  --revisions-changed   根据上游浮动修订是否已更改设置退出代码。
  --server-only         在没有 UI 的情况下运行 bitbake，仅启动服务器（cooker）进程。
  -B BIND, --bind=BIND  要绑定的 bitbake xmlrpc 服务器名称/地址。
  -T SERVER_TIMEOUT, --idle-timeout=SERVER_TIMEOUT
                        设置由于不活动而卸载bitbake服务器的超时时间，设置为-1表示不卸载，																					默认：环境变量BB_SERVER_TIMEOUT。
  --no-setscene         不要运行任何 setscene 任务。 sstate 将被忽略，并构建所需的一切。
  --skip-setscene       如果要执行设置场景任务，则跳过它们。 之前从 sstate 恢复的任务将被保留，																		与 --no-setscene 不同
  --setscene-only       只运行设置场景任务，不运行任何真正的任务。
  --remote-server=REMOTE_SERVER
                        连接到指定的服务器。
  -m, --kill-server     终止任何正在运行的 bitbake 服务器。
  --observe-only        以仅供观察的客户端身份连接服务器。
  --status-only         检查远程 bitbake 服务器的状态。
  -w WRITEEVENTLOG, --write-log=WRITEEVENTLOG
                        将构建的事件日志写入 bitbake 事件 json 文件。 使用（空字符串）自动分配名称。
  --runall=RUNALL       为指定目标的任务图中的任何配方运行指定任务（即使它不会运行）。
  --runonly=RUNONLY     仅运行指定目标的任务图中的指定任务（以及这些任务可能具有的任何任务依赖性）。
```

### 1.5.2 示例

本节将举例说明如何使用 BitBake。

#### 针对单个配方执行任务

执行单个配方文件的任务相对简单。您只需指定相关文件，BitBake 就会对其进行解析并执行指定任务。如果您没有指定任务，BitBake 会执行默认任务，即 "构建"。在执行时，BitBake 会遵从任务间的依赖关系。

```sh
bitbake -b foo_1.0.bb
```

以下命令在 foo.bb 配方文件上运行清理任务：

```sh
bitbake -b foo.bb -c clean
```

**备注**：-b 选项不明确处理配方依赖关系。除调试目的外，建议使用下一节介绍的语法。

#### 针对一组配方文件执行任务

如果要管理多个 .bb 文件，就会产生一些额外的复杂问题。显然，需要有一种方法来告诉 BitBake 有哪些文件可用，以及你想执行其中的哪些文件。此外，还需要有一种方法让每个配方都能在构建时和运行时表达其依赖关系。当多个配方提供相同的功能，或一个配方有多个版本时，必须有一种方法让你表达配方偏好。

如果不使用"-buildfile "或"-b"，bitbake 命令只接受 "PROVIDES"。您不能提供任何其他信息。默认情况下，配方文件一般会 "提供 "其 "packagename"，如下例所示：

```sh
bitbake foo
```

下一个示例 "PROVIDES "软件包名称，并使用"-c "选项告诉 BitBake 只执行 do_clean 任务：

```sh
bitbake -c clean foo
```

#### 执行任务和配方组合列表

当您指定多个目标时，BitBake 命令行支持为各个目标指定不同的任务。例如，假设您有两个目标（或配方）myfirstrecipe 和 mysecondrecipe，您需要 BitBake 为第一个配方运行任务 A，为第二个配方运行任务 B：

```sh
bitbake myfirstrecipe:do_taskA mysecondrecipe:do_taskB
```

#### 生成依赖关系图

BitBake 可以使用点语法生成依赖关系图。您可以使用 [Graphviz](https://www.graphviz.org/) 的 dot 工具将这些图形转换为图像。

生成依赖关系图时，BitBake 会向当前工作目录写入两个文件：

- task-depends.dot：显示任务之间的依赖关系。这些依赖关系与 BitBake 的内部任务执行列表相匹配。


- pn-buildlist：显示待构建目标的简单列表。

要停止依赖常见的依赖项，使用 -I depend 选项，BitBake 就会从图表中省略它们。省略这些信息可以生成更易读的图形。这样，你就可以从图形中删除继承类（如 base.bbclass）的 [DEPENDS](#DEPENDS)。

下面是创建依赖关系图的示例：

```sh
bitbake -g foo
```

下面示例将 OpenEmbedded 中常见的依赖关系从图中删除：

```sh
bitbake -g -I virtual/kernel -I eglibc foo
```

#### 执行多重配置构建

BitBake 可以使用一条命令构建多个映像或软件包，不同的目标需要不同的配置（多配置构建）。在这种情况下，每个目标都被称为 "多配置"。

要完成多重配置构建，必须在构建目录中使用并行配置文件分别定义每个目标的配置。这些 multiconfig 配置文件的位置是特定的。它们必须位于当前构建目录中名为 multiconfig 的 conf 子目录下。以下是两个独立目标的示例，如图 1-1 所示：

![1-1_执行多重配置构建之配置文件创建结构](https://zyb-note-pic.oss-cn-chengdu.aliyuncs.com/linux-source/yocto/bitbake%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/1-1_%E6%89%A7%E8%A1%8C%E5%A4%9A%E9%87%8D%E9%85%8D%E7%BD%AE%E6%9E%84%E5%BB%BA%E4%B9%8B%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E5%88%9B%E5%BB%BA%E7%BB%93%E6%9E%84.png?OSSAccessKeyId=LTAI5tREkNKGRcMiPdgNQUye&Expires=10000000001692772000&Signature=5Whc45p7MAhJVbkzfEaRgtXBaZs%3D)

之所以需要这样的文件层次结构，是因为 BBPATH 变量是在层解析之前构建的。因此，将配置文件作为预配置文件使用是不可能的，除非它位于当前工作目录下。

最低限度，每个配置文件都必须定义机器和 BitBake 用于编译的临时目录。建议的做法是在编译过程中不要重叠使用临时目录。

除了为每个目标分别创建配置文件外，还必须启用 BitBake 以执行多重配置构建。启用方法是在 local.conf 配置文件中设置 BBMULTICONFIG 变量。举个例子，假设你在构建目录中定义了 target1 和 target2 的配置文件。local.conf 文件中的以下语句既能让 BitBake 执行多重配置编译，又能指定两个额外的 multiconfigs：

```sh
BBMULTICONFIG = "target1 target2"
```

目标配置文件就绪并启用 BitBake 以执行多重配置编译后，使用以下命令启动编译：

```sh
bitbake [mc:multiconfigname:]target [[[mc:multiconfigname:]target] ... ]
```

Here is an example for two extra multiconfigs: `target1` and `target2`:

```sh
bitbake mc::target mc:target1:target mc:target2:target
```

#### 启用多重配置构建依赖关系

在多重配置构建过程中，目标（多图标）之间有时会存在依赖关系。例如，假设要为某一特定架构构建镜像，另一不同架构构建镜像的根文件系统必须存在。换句话说，第一个多重配置的镜像依赖于第二个多重配置的根文件系统。这种依赖关系的本质是，构建一个多重配置的配方中的任务依赖于构建另一个多重配置的配方中的任务的完成。

要在多重配置构建中启用依赖项，必须在配方中使用以下语句形式声明依赖项：

```sh
task_or_package[mcdepends] = "mc:from_multiconfig:to_multiconfig:recipe_name:task_on_which_to_depend"
```

为了更好地说明如何使用该语句，请看一个包含两个多重图标（target1 和 target2）的示例：

```sh
image_task[mcdepends] = "mc:target1:target2:image2:rootfs_task"
```

在本例中，from_multiconfig 为 "target1"，to_multiconfig 为 "target2"。包含 image_task 的映像任务取决于用于生成映像 2 的 rootfs_task 的完成情况，而映像 2 与 "target2 "multiconfig 相关联。



一旦设置了该依赖关系，就可以使用 BitBake 命令构建 "target1 "多参数配置，如下所示：

```sh
bitbake mc:target1:image1
```

该命令将执行为 "target1 "multiconfig 创建 image1 所需的所有任务。由于存在依赖关系，BitBake 也会通过 rootfs_task 执行 "target2 "multiconfig 的构建任务。



让一个配方依赖于另一个构建的根文件系统似乎并不那么有用。请考虑对 image1 配方中的语句作如下修改：

```sh
image_task[mcdepends] = "mc:target1:target2:image2:image_task"
```

在这种情况下，BitBake 必须为 "target2 "编译创建 image2，因为 "target1 "编译依赖于它。



由于 "target1 "和 "target2 "已启用多重配置联编，并拥有独立的配置文件，因此 BitBake 会将每个联编的工件放在各自的临时联编目录中。

# 2 执行

运行 BitBake 的主要目的是产生某种输出，如单个可安装包、内核、软件开发工具包，甚至是完整的、特定于板卡的可引导 Linux 映像，包括引导加载器、内核和根文件系统。当然，你也可以在执行 bitbake 命令时加入一些选项，让它执行单个任务、编译单个配方文件、捕获或清除数据，或者只是返回有关执行环境的信息。

本章将介绍使用 BitBake 创建映像时从头到尾的执行过程。执行过程使用以下命令形式启动：

```bash
bitbake target
```

有关 BitBake 命令及其选项的信息，请参阅 "[BitBake 命令](#1.5 BitBake 命令) "部分。

**备注**：执行 BitBake 之前，应在项目的 local.conf 配置文件中设置 BB_NUMBER_THREADS 变量，以利用构建主机上可用的并行线程执行功能。确定编译主机的这一值的常用方法是运行以下程序：`grep processor /proc/cpuinfo`。该命令将返回处理器数量，并将超线程计算在内。因此，带有超线程功能的四核构建主机最有可能显示八个处理器，这就是你要分配给 [BB_NUMBER_THREADS](#BB_NUMBER_THREADS) 的值。一个可能更简单的解决方案是，某些 Linux 发行版（如 Debian 和 Ubuntu）提供了 ncpus 命令。

## 2.1 解析基本配置元数据

BitBake 要做的第一件事就是解析基础配置元数据。基础配置元数据由项目的 bblayers.conf 文件（用于确定 BitBake 需要识别哪些层）、所有必要的 layer.conf 文件（每层一个）和 bitbake.conf 组成。数据本身有多种类型：

- **Recipes**：有关特定软件的详细信息。

- **Class Data**：常见构建信息的抽象（如如何构建 Linux 内核）。

- **Configuration Data**：机器特定的设置、策略决定等。配置数据就像粘合剂，将所有东西粘合在一起。

layer.conf 文件用于构建 [BBPATH](#BBPATH) 和 [BBFILES](#BBFILES) 等关键变量。[BBPATH](#BBPATH) 分别用于搜索 conf 和 classes 目录下的配置文件和类文件。[BBFILES](#BBFILES) 用于查找配方和配方附加文件（.bb 和 .bbappend）。如果没有 bblayers.conf 文件，则假定用户已在环境中直接设置了 [BBPATH](#BBPATH) 和 [BBFILES](#BBFILES) 。

然后，使用刚才构建的 [BBPATH](#BBPATH) 变量定位 bitbake.conf 文件。bitbake.conf 文件还可以使用 include 或 require 指令包含其他配置文件。

在解析配置文件之前，BitBake 会查看某些变量，包括：

- [BB_ENV_PASSTHROUGH](#BB_ENV_PASSTHROUGH)
- [BB_ENV_PASSTHROUGH_ADDITIONS](#BB_ENV_PASSTHROUGH_ADDITIONS)
- [BB_PRESERVE_ENV](#BB_PRESERVE_ENV)
- [BB_ORIGENV](#BB_ORIGENV)
- [BITBAKE_UI](#BITBAKE_UI)



该列表中的前四个变量与 BitBake 在任务执行过程中如何处理 shell 环境变量有关。默认情况下，BitBake 会清除环境变量，并对 shell 执行环境进行严格控制。不过，通过使用前四个变量，您可以对 BitBake 在执行任务时允许在 shell 中使用的环境变量进行控制。有关这些变量的工作原理和使用方法，请参阅 "[向构建任务环境传递信息](#3.6.3 向构建任务环境传递信息)"部分，以及变量词汇表中有关这些变量的信息。

基础配置元数据是全局性的，因此会影响所有配方和执行的任务。

BitBake 首先会在当前工作目录中搜索一个可选的 conf/bblayers.conf 配置文件。预计该文件将包含一个 BBLAYERS 变量，它是一个以空格分隔的 "层 "目录列表。回想一下，如果 BitBake 找不到 bblayers.conf 文件，就会认为用户已经在环境中直接设置了 [BBPATH](#BBPATH) 和 [BBFILES](#BBFILES) 变量。

对于列表中的每个目录（层），都会找到并解析一个 conf/layer.conf 文件，并将 LAYERDIR 变量设置为找到该层的目录。这样做的目的是让这些文件自动为指定的编译目录正确设置  [BBPATH](#BBPATH) 和其他变量。

然后，BitBake 会在用户指定的 BBPATH 中找到 conf/bitbake.conf 文件。该配置文件通常包含 include 指令，用于调入任何其他元数据，如架构、机器、本地环境等特定文件。

BitBake .conf 文件中只允许使用变量定义和包含指令。有些变量会直接影响 BitBake 的行为。这些变量可能是根据前面提到的环境变量从环境中设置的，也可能是在配置文件中设置的。[变量词汇表](#5 变量词汇表)一章列出了所有变量。

在解析配置文件后，BitBake 会使用其最基本的继承机制（通过类文件）来继承一些标准类。当遇到负责获取类的继承指令时，BitBake 就会解析该类。

base.bbclass 文件始终包含在内。配置中使用 [INHERIT](#INHERIT) 变量指定的其他类也会包含在内。BitBake 在 [BBPATH](#BBPATH) 路径下的 classes 子目录中搜索类文件的方式与配置文件相同。

运行以下 BitBake 命令是了解执行环境中使用的配置文件和类文件的好方法：

```bash
bitbake -e > mybb.log
```

检查 mybb.log 的顶部，可以看到执行环境中使用的许多配置文件和类文件。

**备注**：您需要了解 BitBake 如何解析大括号。如果配方在函数中使用了结尾大括号，而该字符没有前导空格，BitBake 会产生解析错误。如果在 shell 函数中使用了一对大括号，则结尾大括号不得位于没有前导空格的行首。下面是一个导致 BitBake 产生解析错误的示例：

```shell
fakeroot create_shar() {
   cat << "EOF" > ${SDK_DEPLOY}/${TOOLCHAIN_OUTPUTNAME}.sh
usage()
{
   echo "test"
   ######  The following "}" at the start of the line causes a parsing error ######
}
EOF
}

Writing the recipe this way avoids the error:
fakeroot create_shar() {
   cat << "EOF" > ${SDK_DEPLOY}/${TOOLCHAIN_OUTPUTNAME}.sh
usage()
{
   echo "test"
   ###### The following "}" with a leading space at the start of the line avoids the error ######
 }
EOF
}
```

## 2.2 定位和解析食谱

在配置阶段，BitBake 将设置 [BBFILES](#BBFILES)。现在，BitBake 将使用它来构建一个要解析的配方列表，以及任何要应用的附加文件（.bbappend）。[BBFILES](#BBFILES) 是一个空格分隔的可用文件列表，支持通配符。例如：

```bash
BBFILES = "/path/to/bbfiles/*.bb /path/to/appends/*.bbappend"
```

BitBake 会解析位于 [BBFILES](#BBFILES) 中的每个配方和附加文件，并将各种变量的值存储到数据存储中。

**备注**：附加文件按照在 [BBFILES](#BBFILES) 中遇到的顺序应用。

对于每个文件，都会制作一份全新的基本配置副本，然后逐行解析配方。任何继承语句都会导致 BitBake 使用 [BBPATH](#BBPATH) 作为搜索路径查找并解析类文件（.bbclass）。最后，BitBake 会按顺序解析在 [BBFILES](#BBFILES) 中找到的任何附加文件。

一个常见的惯例是使用配方文件名来定义元数据。例如，在 bitbake.conf 中，配方名称和版本用于设置变量 [PN](#PN) 和 [PV](#PV)：

```bash
PN = "${@bb.parse.vars_from_file(d.getVar('FILE', False),d)[0] or 'defaultpkgname'}"
PV = "${@bb.parse.vars_from_file(d.getVar('FILE', False),d)[1] or '1.0'}"
```

在此示例中，名为 "something_1.2.3.bb" 的配方会将 [PN](#PN) 设置为 "something"，将 [PV](#PV) 设置为 "1.2.3"。

当配方解析完成时，BitBake 会得到配方定义的任务列表、由键和值组成的数据集以及任务的相关信息。

BitBake 不需要所有这些信息。它只需要其中的一小部分信息就能对食谱做出决定。因此，BitBake 会缓存它感兴趣的值，而不会存储其他信息。经验表明，重新解析元数据比将其写入磁盘再重新加载要快。

在可能的情况下，后续的 BitBake 命令会重复使用配方信息缓存。缓存的有效性是通过首先计算基础配置数据的校验和（参见 [BB_HASHCONFIG_IGNORE_VARS](#BB_HASHCONFIG_IGNORE_VARS)），然后检查校验和是否匹配来确定的。如果校验和与缓存中的数据相匹配，且配方和类文件没有更改，则 BitBake 可以使用缓存。然后，BitBake 会重新加载缓存中的配方信息，而不是从头开始重新解析。

配方文件集允许用户拥有多个包含相同软件包的 .bb 文件库。例如，用户可以很容易地使用它们来制作上游版本库的本地副本，但要对其进行自定义修改，而不希望上游版本库中的内容被修改。下面是一个例子：

```sh
BBFILES = "/stuff/openembedded/*/*.bb /stuff/openembedded.modified/*/*.bb"
BBFILE_COLLECTIONS = "upstream local"
BBFILE_PATTERN_upstream = "^/stuff/openembedded/"
BBFILE_PATTERN_local = "^/stuff/openembedded.modified/"
BBFILE_PRIORITY_upstream = "5"
BBFILE_PRIORITY_local = "10"
```

**备注**：层机制是目前首选的代码收集方法。虽然收集代码仍然存在，但其主要用途是设置层优先级和处理层之间的重叠（冲突）。

## 2.3 Providers 提供商

假设 BitBake 已收到执行目标的指令，并且所有配方文件都已解析，那么 BitBake 就会开始计算如何构建目标。BitBake 会查看每个配方的 [PROVIDES](#PROVIDES) 列表。[PROVIDES](#PROVIDES) 列表是配方的名称列表。每个配方的 [PROVIDES](#PROVIDES) 列表通过配方的 [PN](#PN) 变量隐式创建，通过配方的 [PROVIDES](#PROVIDES) 变量显式创建，而 [PROVIDES](#PROVIDES) 变量是可选的。

当配方使用 [PROVIDES](#PROVIDES) 时，除了隐含的 [PN](#PN) 名称外，该配方的功能可以在其他名称下找到。例如，假设一个名为 keyboard_1.0.bb 的配方包含以下内容：

```sh
PROVIDES += "fullkeyboard"
```

此配方的 [PROVIDES](#PROVIDES) 列表变成了隐式的 "keyboard "和显式的 "fullkeyboard"。因此，keyboard_1.0.bb 中的功能可以在两个不同的名称下找到。

## 2.4 Preferences 首选项

[PROVIDES](#PROVIDES) 列表只是确定目标配方的解决方案的一部分。由于目标可能有多个提供商，因此 BitBake 需要通过确定提供商的偏好来确定提供商的优先级。

一个目标有多个提供程序的常见例子是 "virtual/kernel"，它在每个内核配方的 [PROVIDES](#PROVIDES) 列表中。每台机器通常通过在机器配置文件中使用类似下面的一行来选择最佳内核提供程序：

```sh
PREFERRED_PROVIDER_virtual/kernel = "linux-yocto"
```

默认的 [PREFERRED_PROVIDER](#PREFERRED_PROVIDER) 是与目标名称相同的提供程序。BitBake 会遍历需要构建的每个目标，并使用此流程解析它们及其依赖关系。

由于给定的提供程序可能存在多个版本，了解如何选择提供程序就变得复杂起来。BitBake 默认使用提供程序的最高版本。版本比较的方法与 Debian 相同。你可以使用 [PREFERRED_VERSION](#PREFERRED_VERSION) 变量来指定一个特定的版本。您可以使用 [DEFAULT_PREFERENCE](#DEFAULT_PREFERENCE) 变量来影响顺序。

默认情况下，文件的首选项为 "0"。将 [DEFAULT_PREFERENCE](#DEFAULT_PREFERENCE) 设置为"-1 "后，除非明确引用，否则配方将不会被使用。将 [DEFAULT_PREFERENCE](#DEFAULT_PREFERENCE) 设置为 "1"，则配方可能会被使用。[PREFERRED_VERSION](#PREFERRED_VERSION) 优先于任何 [DEFAULT_PREFERENCE](#DEFAULT_PREFERENCE) 设置。[DEFAULT_PREFERENCE](#DEFAULT_PREFERENCE) 通常用于标记较新和试验性较强的配方版本，直到这些版本经过充分测试被认为是稳定版本。

当某个配方有多个 "版本 "时，除非另有说明，否则 BitBake 默认选择最新版本。如果相关配方的 [DEFAULT_PREFERENCE](#DEFAULT_PREFERENCE) 设置低于其他配方（默认值为 0），则不会被选中。这样，维护配方文件库的人员就可以指定他们对默认选定版本的偏好。此外，用户也可以指定自己喜欢的版本。

如果第一个配方名为 a_1.1.bb，那么 [PN](#PN) 变量将设为 "a"，[PV](#PV) 变量将设为 1.1。

因此，如果存在名为 a_1.2.bb 的配方，BitBake 默认会选择 1.2。不过，如果你在 BitBake 可解析的 .conf 文件中定义了以下变量，你就可以改变这一偏好：

```sh
PREFERRED_VERSION_a = "1.1"
```

**备注**：配方通常会提供两个版本--一个稳定的、有编号的（首选）版本，以及一个从源代码库自动签出的版本，后者被认为更 "先进"，但只能明确选择。例如，在 OpenEmbedded 代码库中，有一个用于 BusyBox 的标准版本化配方文件 busybox_1.22.1.bb，但也有一个基于 Git 的版本 busybox_git.bb，其中明确包含了以下一行内容：

```sh
DEFAULT_PREFERENCE = "-1"
```

以确保除非开发者另有选择，否则编号的稳定版本始终是首选。



## 2.5 Dependencies 依赖关系

BitBake 构建的每个目标都由多个任务组成，如获取、解包、修补、配置和编译。为了在多核系统上获得最佳性能，BitBake 将每个任务都视为一个独立的实体，有自己的依赖关系集。

依赖关系通过几个变量来定义。您可以在本手册末尾的 "变量词汇表 "中找到有关 BitBake 使用的变量的信息。在基本层面上，只需知道 BitBake 在计算依赖关系时使用 [DEPENDS](#DEPENDS) 和 [RDEPENDS](#RDEPENDS) 变量就足够了。

有关 BitBake 如何处理依赖关系的更多信息，请参阅 "[依赖关系](#3.10 Dependencies 依赖关系) "部分。

## 2.6 The Task List 任务清单

根据生成的提供程序列表和依赖关系信息，BitBake 现在可以准确计算出需要运行哪些任务以及运行顺序。执行任务部分有更多关于 BitBake 如何选择下一个执行任务的信息。

## 2.7 Executing Tasks 执行任务

任务可以是 shell 任务或 Python 任务。对于 shell 任务，BitBake 会在 [T](#T)/run.do_taskname.pid 中写入 shell 脚本，然后执行该脚本。生成的 shell 脚本包含所有导出变量，以及扩展了所有变量的 shell 函数。shell 脚本的输出将转入文件  [T](#T)/lod.do_taskname.pid。查看运行文件中已展开的 shell 函数和日志文件中的输出是一种有用的调试技术。

对于 Python 任务，BitBake 在内部执行任务并将信息记录到控制终端。未来版本的 BitBake 将把函数写入文件，类似于 shell 任务的处理方式。日志记录的处理方式也将与 shell 任务类似。

BitBake 运行任务的顺序由任务调度程序控制。可以配置调度程序，并为特定用例定义自定义实现。更多信息，请参阅控制行为的变量：

- [BB_SCHEDULER](#BB_SCHEDULER)
- [BB_SCHEDULERS](#BB_SCHEDULERS)

可以在任务的主函数之前和之后运行函数。这可以使用列出要运行函数的任务的 [prefuncs] 和 [postfuncs] 标志来实现。

## 2.8 Checksums (Signatures) 校验和（签名）

校验和是任务输入的唯一签名。任务的签名可用于确定任务是否需要运行。由于任务输入的变化会触发任务的运行，因此 BitBake 需要检测给定任务的所有输入。对于 shell 任务来说，这一点相当容易，因为 BitBake 会为每个任务生成一个 "运行 "shell 脚本，而且还可以创建一个校验和，让你对任务的数据何时发生变化有一个很好的了解。

使问题更加复杂的是，有些东西不应包含在校验和中。首先是特定任务的实际具体构建路径--工作目录。工作目录是否改变并不重要，因为它不应影响目标软件包的输出。排除工作目录的简单方法是将其设置为某个固定值，然后为 "运行 "脚本创建校验和。BitBake 则更进一步，使用 [BB_BASEHASH_IGNORE_VARS](#BB_BASEHASH_IGNORE_VARS) 变量来定义生成签名时不应该包含的变量列表。

另一个问题是 "运行 "脚本中包含的函数可能会被调用，也可能不会被调用。增量构建解决方案中包含的代码可以找出 shell 函数之间的依赖关系。这些代码用于将 "运行 "脚本剪裁到最小集合，从而缓解了这一问题，并使 "运行 "脚本的可读性大大提高。

到目前为止，我们已经有了 shell 脚本的解决方案。那么 Python 任务呢？尽管这些任务更加困难，但同样的方法也适用。程序需要弄清楚 Python 函数访问了哪些变量，调用了哪些函数。同样，增量构建解决方案包含的代码会首先找出变量和函数的依赖关系，然后为作为任务输入的数据创建校验和。

与工作目录的情况一样，在某些情况下依赖关系也会被忽略。在这种情况下，你可以使用类似下面的行文来指示编译过程忽略依赖关系：

```sh
PACKAGE_ARCHS[vardepsexclude] = "MACHINE"
```

此示例确保 PACKAGE_ARCHS 变量不依赖于 MACHINE 的值，即使它引用了 MACHINE。

同样，在某些情况下，我们需要添加 BitBake 无法找到的依赖项。您可以使用类似下面这样的行文来实现这一目的：

```sh
PACKAGE_ARCHS[vardeps] = "MACHINE"
```

此示例明确添加了 MACHINE 变量作为 PACKAGE_ARCHS 的依赖关系。

例如，在使用内联 Python 的情况下，BitBake 无法找出依赖关系。在调试模式下运行时（即使用 -DDD），BitBake 会在发现无法找出依赖关系的内容时产生输出。

到目前为止，本节的讨论仅限于任务的直接输入。基于直接输入的信息在代码中被称为 "basehash"。不过，任务的间接输入（即已构建并存在于构建目录中的内容）问题仍然存在。特定任务的校验和（或签名）需要添加该特定任务所依赖的所有任务的哈希值。选择添加哪些依赖关系是一项策略决策。不过，这样做的结果是生成一个主校验和，它结合了基哈希值和任务依赖项的哈希值。

在代码层面，有多种方法可以影响基础哈希值和从属任务哈希值。在 BitBake 配置文件中，我们可以为 BitBake 提供一些额外信息，帮助它构建基础哈希值。下面的语句会有效地生成一个全局变量依赖性排除列表，即从不包含在任何校验和中的变量。本示例使用 OpenEmbedded 中的变量来说明这一概念：

```sh
BB_BASEHASH_IGNORE_VARS ?= "TMPDIR FILE PATH PWD BB_TASKHASH BBPATH DL_DIR \
    SSTATE_DIR THISDIR FILESEXTRAPATHS FILE_DIRNAME HOME LOGNAME SHELL \
    USER FILESPATH STAGING_DIR_HOST STAGING_DIR_TARGET COREBASE PRSERV_HOST \
    PRSERV_DUMPDIR PRSERV_DUMPFILE PRSERV_LOCKDOWN PARALLEL_MAKE \
    CCACHE_DIR EXTERNAL_TOOLCHAIN CCACHE CCACHE_DISABLE LICENSE_PATH SDKPKGSUFFIX"
```

上例排除了工作目录，它是 TMPDIR 的一部分。

决定通过依赖关系链包含哪些依赖任务哈希值的规则更为复杂，通常使用 Python 函数来实现。meta/lib/oe/sstatesig.py 中的代码展示了这方面的两个示例，还说明了如何根据需要在系统中插入自己的策略。该文件定义了 OpenEmbedded-Core 使用的基本签名生成器："OEBasicHash"。默认情况下，BitBake 会启用一个虚拟的 "noop "签名处理程序。这意味着其行为与以前的版本相比没有变化。通过 bitbake.conf 文件中的设置，OE-Core 默认使用 "OEBasicHash "签名处理程序：

```sh
BB_SIGNATURE_HANDLER ?= "OEBasicHash"
```

"OEBasicHash" [BB_SIGNATURE_HANDLER](#BB_SIGNATURE_HANDLER) 的主要功能是将任务哈希值添加到戳记文件中。有了它，任何元数据变化都会改变任务哈希值，自动导致任务再次运行。这样就不需要修改 PR 值，元数据的变化也会自动波及整个构建过程。

值得注意的是，签名生成器的最终结果是为构建提供一些依赖和散列信息。这些信息包括:

- BB_BASEHASH_task-taskname: 配方中每个任务的基本哈希值。


- BB_BASEHASH_filename:taskname: 每个从属任务的基本哈希值。


- [BB_TASKHASH](#BB_TASKHASH): 当前运行任务的哈希值。

值得注意的是，BitBake 的"-S "选项可以调试 BitBake 对签名的处理。传递给 -S 的选项允许使用不同的调试模式，可以使用 BitBake 自己的调试函数，也可以使用元数据/签名处理程序本身定义的调试函数。最简单的参数是 "none"（无），它会将一组签名信息写入与指定目标相对应的 STAMPS_DIR。另一个当前可用的参数是 "printdiff"，它会导致 BitBake 尝试建立最接近的签名匹配（例如在 sstate 缓存中），然后在匹配的签名上运行 bitbake-diffsigs，以确定这两个戳记树分歧的戳记和 delta。

**备注**：BitBake 的未来版本很可能会提供通过附加"-S "参数触发的其他签名处理程序。

有关校验和元数据的更多信息，请参阅[任务校验和 Setscene](#3.12 任务校验和 Setscene) 部分。

## 2.9 Setscene 场景

Setscene 流程使 BitBake 能够处理 "预构建 "的人工制品。处理和重用这些工件的能力让 BitBake 不必每次都从头开始构建。相反，BitBake 可以在可能的情况下使用现有的构建工件。

BitBake 需要有可靠的数据来表明一件人工制品是否兼容。上一节中描述的签名提供了一种理想的方式来表示一件工件是否兼容。如果签名相同，对象就可以重复使用。

如果一个对象可以重复使用，那么问题就变成了如何用预制件替换给定的任务或任务集。BitBake 通过 "setscene "流程解决了这个问题。

当 BitBake 被要求构建一个给定的目标时，在构建任何东西之前，它会首先询问它正在构建的任何目标或任何中间目标的缓存信息是否可用。如果缓存信息可用，BitBake 就会使用这些信息，而不是运行主要任务。

BitBake 首先调用 [BB_HASHCHECK_FUNCTION](#BB_HASHCHECK_FUNCTION) 变量所定义的函数，该函数包含一个任务列表和相应的哈希值。该函数设计为快速调用，并会返回一个它认为可以获得工件的任务列表。

接下来，BitBake 会针对返回的每个可能任务，执行该可能工件所涵盖任务的场景版本。任务的场景版本会在任务名称后附加"_setscene "字符串。例如，名称为 xxx 的任务有一个名为 xxx_setscene 的场景任务。任务的 setscene 版本会执行并提供必要的工具，返回成功或失败。

如前所述，一件工具可以涵盖多项任务。例如，如果你已经有了编译好的二进制文件，那么获取编译器就毫无意义了。为了处理这个问题，BitBake 会为每个成功的 setscene 任务调用 [BB_SETSCENE_DEPVALID](#BB_SETSCENE_DEPVALID) 函数，以了解是否需要获取该任务的依赖项。

有关场景元数据的更多信息，请参阅[任务校验和场景](#3.12 任务校验和 Setscene)部分。

## 2.10 Logging

除了通过标准命令行选项来控制编译时的冗长程度外，bitbake 还支持用户通过 [BB_LOGCONFIG]((#BB_LOGCONFIG)) 变量来配置 Python 日志功能。这个变量定义了一个 JSON 或 YAML 日志配置，它会被智能地合并到默认配置中。日志配置的合并规则如下：

- 如果顶层关键字 bitbake_merge 设置为 "False"，用户定义的配置将完全取代默认配置。在这种情况下，所有其他规则都将被忽略。
- 用户配置的顶层版本必须与默认配置的值一致。
- handlers、formatters 或 filters 中定义的任何键值都将合并到默认配置中的同一部分，如果出现冲突，用户指定的键值将取代默认键值。实际上，这意味着如果默认配置和用户配置都指定了名为 myhandler 的处理程序，用户定义的处理程序将取代默认处理程序。为防止用户无意中替换默认处理程序、格式器或过滤器，所有默认处理程序都以 "BitBake" 作为前缀。
- 如果用户定义的日志记录器的 bitbake_merge 关键字设置为 "False"，则该日志记录器将被用户配置完全取代。在这种情况下，其他规则将不适用于该记录仪。
- 给定日志记录器的所有用户定义的过滤器和处理程序属性都将与默认日志记录器的相应属性合并。例如，如果用户配置在 BitBake.SigGen 中添加了名为 myFilter 的过滤器，而默认配置添加了名为 BitBake.defaultFilter 的过滤器，那么这两个过滤器都将应用于日志记录器。

第一个例子是创建 hashequiv.json 用户日志配置文件，将所有 VERBOSE 或更高优先级的哈希等价相关信息记录到名为 hashequiv.log 的文件中：

```json
{
    "version": 1,
    "handlers": {
        "autobuilderlog": {
            "class": "logging.FileHandler",
            "formatter": "logfileFormatter",
            "level": "DEBUG",
            "filename": "hashequiv.log",
            "mode": "w"
        }
    },
    "formatters": {
            "logfileFormatter": {
                "format": "%(name)s: %(levelname)s: %(message)s"
            }
    },
    "loggers": {
        "BitBake.SigGen.HashEquiv": {
            "level": "VERBOSE",
            "handlers": ["autobuilderlog"]
        },
        "BitBake.RunQueue.HashEquiv": {
            "level": "VERBOSE",
            "handlers": ["autobuilderlog"]
        }
    }
}
```

Then set the [BB_LOGCONFIG](#BB_LOGCONFIG) variable in `conf/local.conf`:

```sh
BB_LOGCONFIG = "hashequiv.json"
```

另一个例子是 warn.json 文件，它将所有警告和优先级更高的信息记录到 warn.log 文件中：

```json
{
    "version": 1,
    "formatters": {
        "warnlogFormatter": {
            "()": "bb.msg.BBLogFormatter",
            "format": "%(levelname)s: %(message)s"
        }
    },

    "handlers": {
        "warnlog": {
            "class": "logging.FileHandler",
            "formatter": "warnlogFormatter",
            "level": "WARNING",
            "filename": "warn.log"
        }
    },

    "loggers": {
        "BitBake": {
            "handlers": ["warnlog"]
        }
    },

    "@disable_existing_loggers": false
}
```

请注意，BitBake 用于结构化日志的辅助类是在 lib/bb/msg.py 中实现的。













# 3 语法和运算符

BitBake 文件有自己的语法。该语法与其他几种语言有相似之处，但也有一些独特的功能。本节将介绍可用的语法和运算符，并提供示例。

## 3.1 基本语法

本节提供了一些基本语法示例。

### 3.1.1 基本变量设置

下面的示例将 VARIABLE 设置为 "value"。该赋值在语句解析时立即发生。这是一个 "硬 "赋值。

```sh
VARIABLE = "value"
```

与预期一样，如果在赋值中包含前导空格或尾部空格，空格将被保留：

```sh
VARIABLE = " value"
VARIABLE = "value "
```

将 VARIABLE 设置为`""`会将其设置为空字符串，而将变量设置为`" "`则会将其设置为空格（即这两个值并不相同）。

```sh
VARIABLE = ""
VARIABLE = " "
```

在设置变量值时，可以使用单引号代替双引号。这样可以使用包含双引号的值：

```sh
VARIABLE = 'I have a " in my value'
```

**备注**：与 Bourne shell 不同，单引号在所有其他方面的作用与双引号相同。它们不会抑制变量扩展。

### 3.1.2 修改现有变量

有时需要修改现有变量。以下是一些需要修改现有变量的情况：

- 定制使用变量的食谱。


- 更改 *.bbclass 文件中使用的变量默认值。


- 更改 *.bbappend 文件中的变量，以覆盖原始配方中的变量。


- 更改配置文件中的变量，使其值覆盖现有配置。

更改变量值有时取决于变量值最初是如何分配的，也取决于更改的预期目的。特别是，当你在一个有默认值的变量上附加一个值时，得到的值可能并不是你所期望的。在这种情况下，您提供的值可能会取代该值，而不是追加到默认值中。

如果在更改变量值后出现无法解释的情况，可以使用 BitBake 检查可疑变量的实际值。您可以对配置和配方级别的更改进行这些检查：

- 要更改配置，请使用以下方法：

    ```sh
    bitbake -e
    ```

    该命令在解析配置文件（如 local.conf、bblayers.conf、bitbake.conf 等）后显示变量值。

    **备注**：在命令输出中，导出到环境中的变量会在前面加上 "export "字符串。

- 要查找特定配方中给定变量的变化，请使用以下方法：

    ```sh
    bitbake recipename -e | grep VARIABLENAME=\"
    ```

    该命令将检查变量是否被添加到特定配方中。

### 3.1.3 Line Joining 线性连接

在函数之外，BitBake 在解析语句之前，会将以反斜杠字符`\`结尾的行与下一行连接起来。字符`\`的最常见用法是将变量赋值分隔成多行，如下例所示：

```sh
FOO = "bar \
       baz \
       qaz"
```

在连接行时，`\`字符及其后面的换行符都会被删除。因此，FOO 的值中不会出现换行符。

再看下面这个例子，两个赋值都把 "barbaz "赋给了 FOO：

```sh
FOO = "barbaz"
FOO = "bar\
baz"
```

**备注**：BitBake 不解释变量值中的转义序列，如"\n"。要使这些转义序列产生作用，必须将变量值传递给能解释转义序列的实用程序，如 printf 或 echo -n。

### 3.1.4 变量扩展

变量可以引用其他变量的内容，其语法类似于 Bourne shell 中的变量扩展。以下赋值的结果是 A 包含 "aval"，B 等价于 "preavalpost"。

```sh
A = "aval"
B = "pre${A}post"
```

**备注**：与 Bourne shell 不同，大括号是强制性的：只有 `${FOO}`而不是`$FOOO`才被视为 FOO 的扩展。

"="操作符不会立即展开右侧的变量引用。相反，在实际使用赋值的变量之前，会延迟展开。结果取决于引用变量的当前值。下面的示例可以说明这种行为：

```sh
A = "${B} baz"
B = "${C} bar"
C = "foo"
*At this point, ${A} equals "foo bar baz"*
C = "qux"
*At this point, ${A} equals "qux bar baz"*
B = "norf"
*At this point, ${A} equals "norf baz"*
```

这种行为与[立即变量扩展（:=）](#3.1.7 立即变量扩展 :=)运算符形成鲜明对比。

如果在一个不存在的变量上使用变量扩展语法，字符串将保持原样。例如，在下面的赋值中，只要 FOO 不存在，BAR 就会扩展为字面字符串"${FOO}"。

```sh
BAR = "${FOO}"
```

### 3.1.5  设置默认值 ?=

您可以使用`?=`操作符对变量进行 "软" 赋值。如果在语句解析时变量未定义，则可以使用这种赋值方式定义变量；如果变量有值，则可以不定义变量值。下面是一个例子：

```sh
A ?= "aval"
```

如果在解析该语句时 A 已被设置，变量将保留其值。但如果 A 未被设置，变量将被设置为 "aval"。

**备注**：该赋值是即时赋值。因此，如果一个变量存在多个`?=`赋值，则最终会使用第一个赋值。

### 3.1.6 设置弱默认值 ??=

变量的弱缺省值是指在没有通过其他赋值操作符赋值的情况下，该变量将扩展到的值。操作符`??=`立即生效，并替换之前定义的弱缺省值。下面是一个示例：

```sh
W ??= "x"
A := "${W}" # Immediate variable expansion
W ??= "y"
B := "${W}" # Immediate variable expansion
W ??= "z"
C = "${W}"
W ?= "i"
```

解析后，我们将得到：

```sh
A = "x"
B = "y"
C = "i"
W = "i"
```

附加和预置非覆盖样式将不会替代弱默认值，这意味着在解析后：

```sh
W ??= "x"
W += "y"
```

我们将得到：

```sh
W = " y"
```

另一方面，覆盖式追加/预追加/删除会在任何活动的弱缺省值被替换后应用：

```sh
W ??= "x"
W:append = "y"
```

解析后，我们将得到：

```sh
W = "xy"
```

### 3.1.7 立即变量扩展 :=

`:=`操作符会导致变量内容立即展开，而不是在实际使用变量时展开：

```sh
T = "123"
A := "test ${T}"
T = "456"
B := "${T} ${C}"
C = "cval"
C := "${C}append"
```

在本例中，尽管 T 的最终值为 "456"，但 A 中仍包含 "test 123"。变量 B 最终将包含 "456 cvalappend"。这是因为在（立即）扩展过程中，对未定义变量的引用将保持不变。这与 GNU Make 不同，GNU Make 将未定义变量扩展为空。变量 C 包含 "cvalappend"，因为 ${C} 会立即展开为 "cval"。

### 3.1.8 用空格追加 (+=) 和预追加 (=+)

数值的追加和预追加很常见，可以使用运算符`+=`和`=+`来实现。这些操作符会在当前值和预置值或追加值之间插入一个空格。

这些运算符在解析过程中立即生效。下面是一些例子：

```sh
B = "bval"
B += "additionaldata"
C = "cval"
C =+ "test"
```

变量 B 包含 "bval additionaldata"，C 包含 "test cval"。

### 3.1.9 无空格的附加 (.=) 和预置 (=.)

如果要追加或预置值而不插入空格，请使用`.=`或`=.`操作符。

这些运算符在解析过程中立即生效。下面是一些例子：

```sh
B = "bval"
B .= "additionaldata"
C = "cval"
C =. "test"
```

变量 B 包含 "bvaladditionaldata"，C 包含 "testcval"。

### 3.1.10 追加和预追加（覆盖样式语法）

您还可以使用覆盖样式语法追加和预置变量值。使用这种语法时，不会插入空格。

这些运算符与`:=`、`.=`、`=.`、`+=`和`=+`运算符的不同之处在于，它们的效果是在变量展开时应用，而不是立即应用。下面是一些示例：

```sh
B = "bval"
B:append = " additional data"
C = "cval"
C:prepend = "additional data "
D = "dval"
D:append = "additional data"
```

变量 B 变为 "bval additional data"，C 变为 "additional data cval"。变量 D 变成 "dvaladditional data"。

**备注**：使用覆盖语法时，必须控制所有空格。

**备注**：重载按以下顺序应用：":append"、":prepend"、":remove"。

还可以对 shell 函数和 BitBake 风格 Python 函数进行追加和预追加。有关示例，请参阅 "Shell 函数" 和 "BitBake 风格 Python 函数" 部分。

## 3.4 共享功能

### 3.4.5 INHERIT 配置指令

创建配置文件（.conf）时，可以使用 [INHERIT](#INHERIT) 配置指令来继承一个类。BitBake 仅支持在配置文件中使用该指令。

举个例子，假设需要从配置文件中继承一个名为 abc.bbclass 的类文件，如下所示：

```sh
INHERIT += "abc"
```

在解析过程中，该配置指令会导致指定的类被继承。与继承指令一样，.bbclass 文件必须位于 [BBPATH](#BBPATH) 指定目录中的 "classes "子目录下。

**备注**：由于 .conf 文件在 BitBake 执行过程中首先被解析，因此使用 [INHERIT](#INHERIT) 继承一个类实际上是全局继承该类（即继承所有配方）。

如果要使用该指令继承多个类，可以在 local.conf 文件的同一行中提供。使用空格分隔类。下面的示例展示了如何同时继承 autotools 和 pkgconfig 两个类：

```sh
INHERIT += "autotools pkgconfig"
```

## 3.5 函数

### 3.5.1 Shell 函数

用 shell 脚本编写的函数可以作为函数、任务或两者直接执行。它们也可以被其他 shell 函数调用。下面是一个 shell 函数定义示例：

```sh
some_function () {
    echo "Hello World"
}
```

在配方或类文件中创建这类函数时，需要遵循 shell 编程规则。脚本由 /bin/sh 执行，它可能不是一个 bash shell，但也可能是诸如 dash 这样的 shell。您不应该使用 Bash 特有的脚本（bashisms）。

覆盖和覆盖式操作符（如 :append 和 :prepend）也可应用于 shell 函数。最常见的应用是在 .bbappend 文件中使用，以修改主代码中的函数。它也可用于修改从类继承的函数。

举例如下：

```sh
do_foo() {
    bbplain first
    fn
}

fn:prepend() {
    bbplain second
}

fn() {
    bbplain third
}

do_foo:append() {
    bbplain fourth
}
```

运行 do_foo 会打印出以下内容：

```sh
recipename do_foo: first
recipename do_foo: second
recipename do_foo: third
recipename do_foo: fourth
```

**备注**：覆盖和覆盖式操作符可应用于任何 shell 函数，而不仅仅是[任务](#3.6 Tasks 任务)。

您可以使用 `bitbake -e recipename` 命令查看应用所有覆盖后的最终组装函数。

### 3.5.2 BitBake 样式的 Python 函数

这些函数用 Python 编写，由 BitBake 或其他 Python 函数使用 bb.build.exec_func() 执行。

BitBake 函数的一个示例是：

```python
python some_python_function () {
    d.setVar("TEXT", "Hello World")
    print d.getVar("TEXT")
}
```

因为已经导入了 Python 的 "bb "和 "os "模块，所以不需要再导入这些模块。另外，在这些函数中，数据存储 ("d") 是一个全局变量，总是自动可用的。

**备注**：变量表达式 (例如 ${X} ) 在 Python 函数中不再展开。这种行为是有意为之，目的是让您可以自由地为可展开表达式设置变量值，而不会过早地展开它们。如果您确实希望在 Python 函数中展开变量，请使用 `d.getVar("X")` 。或者，对于更复杂的表达式，使用 `d.expand()`。

与 shell 函数类似，您也可以在 BitBake 风格的 Python 函数中应用覆盖和覆盖式操作符。

举例如下：

```python
python do_foo:prepend() {
    bb.plain("first")
}

python do_foo() {
    bb.plain("second")
}

python do_foo:append() {
    bb.plain("third")
}
```

运行 do_foo 会打印出以下内容：

```sh
recipename do_foo: first
recipename do_foo: second
recipename do_foo: third
```

您可以使用 `bitbake -e recipename` 命令查看应用所有覆盖后的最终组装函数。

### 3.5.3 Python 函数

这些函数用 Python 编写，由其他 Python 代码执行。Python 函数的例子是您打算从内联 Python 或从其他 Python 函数中调用的实用程序函数。下面是一个例子：

```python
def get_depends(d):
    if d.getVar('SOMECONDITION'):
        return "dependencywithcond"
    else:
        return "dependency"

SOMECONDITION = "1"
DEPENDS = "${@get_depends(d)}"
```

这将导致 DEPENDS 包含 dependencywithcond。

下面是一些关于 Python 函数的知识：

- Python 函数可以接受参数。


- BitBake 数据存储不会自动可用。因此，您必须将其作为参数传递给函数。


- "bb" 和 "os" Python 模块自动可用。您无需导入它们。

### 3.5.4 BitBake 风格 Python 函数与 Python 函数的比较

以下是 BitBake 风格 Python 函数与用 "def "定义的普通 Python 函数的一些重要区别：

## 3.6 Tasks 任务

任务是 BitBake 的执行单元，它构成了 BitBake 可以为给定配方运行的步骤。任务仅在配方和类（即 .bb 文件和包含或继承自 .bb 文件的文件）中受支持。按照惯例，任务名称以 "do_"开头。

### 3.6.3 向构建任务环境传递信息

在运行任务时，BitBake 会严格控制构建任务的 shell 执行环境，以确保来自构建机器的不必要污染不会影响构建。

**备注**：默认情况下，BitBake 会对环境进行清理，只包含导出或列在直通列表中的内容，以确保编译环境的可重复性和一致性。您可以通过设置 [BB_PRESERVE_ENV](#BB_PRESERVE_ENV) 变量来阻止这种 "清理"。

因此，如果您确实希望将某些内容传递到构建任务环境中，就必须采取这两个步骤：

1. 告诉 BitBake 从环境中加载您想要的内容到数据存储中。这可以通过 [BB_ENV_PASSTHROUGH](#BB_ENV_PASSTHROUGH) 和 [BB_ENV_PASSTHROUGH_ADDITIONS](#BB_ENV_PASSTHROUGH_ADDITIONS) 变量来实现。例如，假设你想阻止编译系统访问 $HOME/.ccache 目录。下面的命令将环境变量 CCACHE_DIR 添加到 BitBake 的直通列表中，以允许该变量进入数据存储：

    ```sh
    export BB_ENV_PASSTHROUGH_ADDITIONS="$BB_ENV_PASSTHROUGH_ADDITIONS CCACHE_DIR"
    ```

2. 告诉 BitBake 将加载到数据存储中的内容导出到每个运行任务的任务环境中。将环境中的内容加载到数据存储中（上一步）只能使其在数据存储中可用。要将其导出到每个运行任务的任务环境中，请在本地配置文件 local.conf 或发行版配置文件中使用类似下面的命令：

    ```sh
    export CCACHE_DIR
    ```

    **备注**：前面步骤的一个副作用是，BitBake 会将变量作为编译过程的依赖项记录到 setscene 校验和等文件中。如果这样做会导致不必要的任务重建，也可以标记变量，这样 setscene 代码在创建校验和时就会忽略该依赖关系。

有时，从原始执行环境中获取信息是非常有用的。BitBake 会将原始环境的副本保存到一个名为 [BB_ORIGENV](#BB_ORIGENV) 的特殊变量中。

[BB_ORIGENV](#BB_ORIGENV) 变量返回一个数据存储对象，可以使用标准数据存储操作符（如 getVar(,False)）进行查询。例如，数据存储对象在查找原始 DISPLAY 变量时非常有用。下面是一个示例：

```sh
origenv = d.getVar("BB_ORIGENV", False)
bar = origenv.getVar("BAR", False)
```

上例从原始执行环境返回 BAR。

## 3.10 Dependencies 依赖关系

为了实现高效的并行处理，BitBake 在任务级别处理依赖关系。依赖关系既可能存在于单个配方中的任务之间，也可能存在于不同配方中的任务之间。下面分别举例说明：

- 对于单个配方中的任务，配方的 do_configure 任务可能需要在 do_compile 任务运行前完成。


- 对于不同配方中的任务，一个配方的 do_configure 任务可能需要另一个配方的 do_populate_sysroot 任务先完成，以便另一个配方提供的库和头文件可用。

本节将介绍几种声明依赖关系的方法。请记住，尽管声明依赖关系的方式不同，但它们都只是任务之间的依赖关系。



### 3.10.1 .bb 文件内部的依赖关系

BitBake 使用 addtask 指令管理指定配方文件内部的依赖关系。您可以使用 addtask 指令来指示某个任务何时依赖于其他任务，或者其他任务何时依赖于该配方。下面是一个示例：

```sh
addtask printdate after do_fetch before do_build
```

在本例中，do_printdate 任务依赖于 do_fetch 任务的完成，而 do_build 任务依赖于 do_printdate 任务的完成。

**备注**：要运行一项任务，它必须直接或间接依赖于其他计划运行的任务。下面是一些示例：

- do_configure 之前的 addtask mytask 指令会使 do_mytask 在 do_configure 运行之前运行。请注意，只有当 do_mytask 的输入校验和在上次运行后发生变化时，它才会继续运行。do_mytask 的[输入校验和](#2.8 Checksums (Signatures) 校验和（签名）)发生变化也会间接导致 do_configure 运行。

- do_configure 后的 addtask mytask 指令本身不会导致 do_mytask 运行：

    ```sh
    bitbake recipe -c mytask
    ```

    将 do_mytask 声明为其他计划运行的任务的依赖项，也会导致该任务运行。无论如何，该任务都会在 do_configure 之后运行。

### 3.10.2 构建依赖关系

BitBake 使用 [DEPENDS](#DEPENDS) 变量来管理构建时间依赖关系。任务的 [deptask] 变量标志着 [DEPENDS](#DEPENDS) 中列出的每个项目的任务必须在该任务执行前完成。下面是一个例子：

```sh
do_configure[deptask] = "do_populate_sysroot"
```

在本例中，[DEPENDS](#DEPENDS) 中每个项目的 do_populate_sysroot 任务必须在 do_configure 执行之前完成。

### 3.10.3 运行时依赖项

BitBake 使用 [PACKAGES](#PACKAGES)、[RDEPENDS](#RDEPENDS) 和 [RRECOMMENDS](#RRECOMMENDS) 变量来管理运行时依赖关系。

[PACKAGES](#PACKAGES) 变量列出了运行时软件包。每个软件包都可以有 [RDEPENDS](#RDEPENDS) 和 [RRECOMMENDS](#RRECOMMENDS) 运行时依赖关系。任务的 [rdeptask] 标志用于标示每个运行时依赖项的任务，该任务必须在执行前完成。

```sh
do_package_qa[rdeptask] = "do_packagedata"
```

在前面的例子中，[RDEPENDS](#RDEPENDS) 中每个项目的 do_packagedata 任务必须在 do_package_qa 执行之前完成。虽然 [RDEPENDS](#RDEPENDS) 包含运行时依赖关系命名空间中的条目，但 BitBake 知道如何将它们映射回构建时依赖关系命名空间，而任务就是在构建时依赖关系命名空间中定义的。

### 3.10.4 递归依赖关系

BitBake 使用 [recrdeptask] 标记来管理递归任务依赖关系。BitBake 会查看当前配方的构建时和运行时依赖关系，查看任务的任务间依赖关系，然后为列出的任务添加依赖关系。一旦 BitBake 完成了这些工作，它就会递归地查看这些任务的依赖关系。递归过程一直持续到发现并添加所有依赖关系为止。

[recrdeptask] 标志最常用于需要等待某些任务 "全局 "完成的高级配方中。例如，image.bbclass 有以下内容：

```sh
do_rootfs[recrdeptask] += "do_packagedata"
```

该语句表示，在 do_rootfs 任务运行之前，必须先运行当前配方的 do_packagedata 任务，以及从映像配方可到达的所有配方（通过依赖关系）。

BitBake 允许任务通过在任务列表中引用自身来递归依赖于自身：

```sh
do_a[recrdeptask] = "do_a do_b"
```

与之前的方式相同，这意味着当前配方的 do_a 和 do_b 任务以及该配方可访问（通过依赖关系）的所有配方必须在 do_a 任务运行前运行。在这种情况下，BitBake 将忽略当前配方的 do_a 任务循环依赖关系。

### 3.10.5 任务间的依赖关系

BitBake 以更通用的形式使用 [depends] 标志来管理任务间的依赖关系。这种更通用的形式允许对特定任务进行相互依赖检查，而不是对 [DEPENDS](#DEPENDS) 中的数据进行检查。下面是一个例子：

```sh
do_patch[depends] = "quilt-native:do_populate_sysroot"
```

在本例中，目标 quilt-native 的 do_populate_sysroot 任务必须在 do_patch 任务执行前完成。

[rdepends]标志的作用与此类似，但它使用的是运行时命名空间中的目标，而不是编译时依赖命名空间中的目标。



## 3.12 任务校验和 Setscene

BitBake 使用校验和（或签名）以及 setscene 来确定是否需要运行任务。本节将介绍这一过程。为帮助理解 BitBake 是如何做到这一点的，本节假定了一个基于 OpenEmbedded 元数据的示例。

这些校验和存储在 [STAMP]((#STAMP)) 中。您可以使用以下 BitBake 命令检查校验和：

```sh
bitbake-dumpsigs
```

该命令以可读格式返回签名数据，允许您检查 OpenEmbedded 编译系统生成签名时使用的输入。例如，使用`bitbake-dumpsigs`可以检查 C 应用程序（如 bash）的 do_compile 任务的 "sigdata"。运行该命令还会发现，"CC "变量是散列输入的一部分。对该变量的任何更改都会使印记失效，并导致 do_compile 任务运行。

下面列出了相关变量：

- [BB_HASHCHECK_FUNCTION](#BB_HASHCHECK_FUNCTION)：指定在任务执行的 "setscene "部分调用的函数名称，以便验证任务哈希值列表。

- [BB_SETSCENE_DEPVALID](#BB_SETSCENE_DEPVALID)：指定 BitBake 调用的函数，用于确定 BitBake 是否需要满足 setscene 依赖关系。

- [BB_TASKHASH](#BB_TASKHASH)：在执行中的任务中，该变量保存当前启用的签名生成器返回的任务哈希值。

- [STAMP](#STAMP)：创建图章文件的基本路径。

- [STAMPCLEAN](#STAMPCLEAN)：同样是创建图章文件的基本路径，但可以使用通配符匹配一定范围的文件进行清除操作。





















# 5 变量词汇表

## DEPENDS

列出配方的构建时依赖项（即其他配方文件）。

请看这个简单的例子，两个配方分别名为 "a" 和 "b"，它们生成的软件包名称相似。在本例中，DEPENDS 语句出现在 "a" 配方中：

```sh
DEPENDS = "b"
```

这里的依赖关系是，配方 "a"的 do_configure 任务依赖于配方 "b" 的 do_populate_sysroot 任务。这意味着配方 "b" 放入 sysroot 的任何内容在配方 "a" 配置自己时都是可用的。

有关运行时依赖关系的信息，请参阅 [RDEPENDS](#RDEPENDS) 变量。

## RDEPENDS

列出软件包的运行时依赖包（即其他软件包），必须安装这些依赖包才能使构建的软件包正常运行。如果在构建过程中找不到此列表中的软件包，就会出现构建错误。

由于 [RDEPENDS](#RDEPENDS) 变量适用于正在编译的软件包，因此应始终以附带软件包名称的形式使用该变量。例如，假设你正在构建一个依赖于 perl 软件包的开发软件包。在这种情况下，你将使用下面的 [RDEPENDS](#RDEPENDS) 语句：

```sh
RDEPENDS:${PN}-dev += "perl"
```

在本例中，开发包依赖于 perl 包。因此， [RDEPENDS](#RDEPENDS) 变量中包含 ${PN}-dev 软件包名称。

BitBake 支持指定版本化的依赖关系。虽然语法因打包格式而异，但 BitBake 隐藏了这些差异。以下是使用 [RDEPENDS](#RDEPENDS) 变量指定版本的一般语法：

```sh
RDEPENDS:${PN} = "package (operator version)"
```

对于操作员，您可以指定以下内容：

```sh
=
<
>
<=
>=
```

例如，下面的代码将依赖版本为 1.2 或更高的软件包 foo：

```sh
RDEPENDS:${PN} = "foo (>= 1.2)"
```

有关联编时依赖关系的信息，请参阅 [DEPENDS](#DEPENDS) 变量。

## RRECOMMENDS

可扩展正在联编的软件包可用性的软件包列表。正在编译的软件包并不依赖于此软件包列表才能成功编译，但需要它们来扩展可用性。要指定软件包的运行时依赖关系，请参阅 [RDEPENDS](#RDEPENDS) 变量。

BitBake 支持指定版本化推荐。虽然语法因打包格式而异，但 BitBake 隐藏了这些差异。以下是使用 [RRECOMMENDS](#RRECOMMENDS) 变量指定版本的一般语法：

```sh
RRECOMMENDS:${PN} = "package (operator version)"
```

对于操作员，您可以指定以下内容：

```sh
=
<
>
<=
>=
```

例如，下面的代码将依赖版本为 1.2 或更高的软件包 foo：

```sh
RDEPENDS:${PN} = "foo (>= 1.2)"
```

## BBPATH

BitBake 用来查找类（.bbclass）和配置（.conf）文件。该变量类似于 PATH 变量。

如果从联编目录之外的目录运行 BitBake，必须确保将 BBPATH 设为指向联编目录。像设置其他环境变量一样设置该变量，然后运行 BitBake：

```sh
BBPATH="build_directory"
export BBPATH
bitbake target
```

## BBFILES

以空格分隔的 BitBake 用来构建软件的配方文件列表。

指定配方文件时，可以使用 Python 的 glob 语法进行模式匹配。有关语法的详细信息，请点击前面的链接查看文档。

## BB_LOGCONFIG

指定包含用户日志配置的配置文件名称。更多信息请参阅[日志记录](#2.10 Logging)。

## BB_LOGFMT

指定保存在 ${[T]((#T))} 中的日志文件名。默认情况下，[BB_LOGFMT]((#BB_LOGFMT)) 变量未定义，日志文件名按以下形式创建：

```sh
log.{task}.{pid}
```

如果要强制日志文件使用特定名称，可以在配置文件中设置该变量。

## BB_ENV_PASSTHROUGH

指定允许从外部环境进入 BitBake 数据存储的内部变量列表。如果未指定该变量的值（默认值），则使用以下列表：[BBPATH](#BBPATH)、[BB_PRESERVE_ENV](#BB_PRESERVE_ENV)、[BB_ENV_PASSTHROUGH](#BB_ENV_PASSTHROUGH) 和 [BB_ENV_PASSTHROUGH_ADDITIONS](#BB_ENV_PASSTHROUGH_ADDITIONS)。

## BB_ENV_PASSTHROUGH_ADDITIONS

指定允许从外部环境到 BitBake 数据库的额外变量集。该变量列表位于 [BB_ENV_PASSTHROUGH](#BB_ENV_PASSTHROUGH) 中的内部变量列表之上。

## BB_PRESERVE_ENV

禁用环境过滤，允许所有变量从外部环境进入 BitBake 的数据存储。

**备注**：您必须在外部环境中设置该变量，以使其发挥作用。

## BB_ORIGENV

包含运行 BitBake 的原始外部环境的副本。该副本是在任何配置为从外部环境传递的变量值被过滤到 BitBake 数据存储之前获取的。

**备注**：该变量的内容是一个数据存储对象，可以使用正常的数据存储操作进行查询。

## BITBAKE_UI

用于指定运行 BitBake 时要使用的用户界面模块。使用此变量等同于使用 -u 命令行选项。

**备注**：您必须在外部环境中设置该变量，以使其发挥作用。

## BB_NUMBER_THREADS

BitBake 在同一时间应并行运行的最大任务数。如果您的主机开发系统支持多内核，一个好的经验法则是将此变量设置为内核数的两倍。

## INHERIT

将全局继承指定的一个或多个类。类中的匿名函数不会在基本配置和每个配方中执行。OpenEmbedded 构建系统会忽略个别配方中对 [INHERIT](#INHERIT) 的更改。

有关 [INHERIT](#INHERIT) 的更多信息，请参阅 [INHERIT 配置指令](#3.4.5 INHERIT 配置指令)部分。

## PN

食谱名称。

## PR

食谱的修订。

## PV

食谱的版本。

## BB_HASHCONFIG_IGNORE_VARS

列出从基础配置校验中排除的变量，用于确定缓存是否可以重复使用。

BitBake 决定是否重新解析主元数据的方法之一，是对基础配置数据的数据存储中的变量进行校验。在检查是否重新解析并重建缓存时，通常要排除一些变量。例如，你通常会排除 TIME 和 DATE，因为这些变量总是在变化。如果不排除它们，BitBake 将永远不会重新使用缓存。

## PROVIDES

可用于查找特定配方的别名列表。默认情况下，配方自身的 PN 已隐含在 [PROVIDES](#PROVIDES) 列表中。如果配方使用了 [PROVIDES](#PROVIDES)，那么附加别名就是配方的同义词，可以在构建过程中满足 [DEPENDS](#DEPENDS) 指定的其他配方的依赖关系。

下面是配方文件 libav_0.8.11.bb 中的 [PROVIDES](#PROVIDES) 语句示例：

```bash
PROVIDES += "libpostproc"
```

[PROVIDES](#PROVIDES) 语句导致 "libav "配方也被称为 "libpostproc"。

[PROVIDES](#PROVIDES) 机制除了提供备用名称的配方外，还可用于实现虚拟目标。虚拟目标是与某些特定功能（如 Linux 内核）相对应的名称。提供相关功能的食谱会在 [PROVIDES](#PROVIDES) 中列出虚拟目标。依赖于相关功能的食谱可以在 [DEPENDS](#DEPENDS) 中包含虚拟目标，以便于选择提供者。

通常，虚拟目标的名称形式为 "virtual/function"（如 "virtual/kernel"）。斜线只是名称的一部分，在语法上没有任何意义。

## PREFERRED_PROVIDER

当多个配方提供相同项目时，决定优先选择哪个配方。该变量的后缀应始终是所提供项目的名称，并且应将其设置为要优先考虑的配方的 [PN](#PN)。举例如下：

```bash
PREFERRED_PROVIDER_virtual/kernel ?= "linux-yocto"
PREFERRED_PROVIDER_virtual/xserver = "xserver-xf86"
PREFERRED_PROVIDER_virtual/libgl ?= "mesa"
```

## PREFERRED_PROVIDERS

确定在多个配方提供相同项目的情况下，应优先选择哪个配方。在功能上，[PREFERRED_PROVIDERS](#PREFERRED_PROVIDERS) 与 [PREFERRED_PROVIDER](#PREFERRED_PROVIDERS) 相同。不过，[PREFERRED_PROVIDERS](#PREFERRED_PROVIDERS) 变量可以让您使用以下形式定义多种情况下的首选项：

```bash
PREFERRED_PROVIDERS = "xxx:yyy aaa:bbb ..."
```

该格式可方便地替代以下格式：

```bash
PREFERRED_PROVIDER_xxx = "yyy"
PREFERRED_PROVIDER_aaa = "bbb"
```

## PREFERRED_VERSION

如果一个配方有多个版本，该变量将决定优先选择哪个版本。您必须在该变量后缀上您要选择的 [PN](#PN)，并相应设置 [PV](#PV) 为优先级。

[PREFERRED_VERSION](#PREFERRED_VERSION) 变量通过"%"字符支持有限的通配符使用。您可以使用该字符匹配任意数量的字符，这在指定包含可能更改的长版本号的版本时非常有用。下面是两个例子：

```bash
PREFERRED_VERSION_python = "2.7.3"
PREFERRED_VERSION_linux-yocto = "4.12%"
```

**重要**："%" 字符的使用受到限制，只能在字符串的末尾使用。不能在字符串的其他位置使用通配符。

如果指定版本的配方不可用，系统将显示警告信息。如果希望显示错误信息，请参阅 [REQUIRED_VERSION](#REQUIRED_VERSION)。

## REQUIRED_VERSION

如果配方有多个版本，该变量将决定优先选择哪个版本。[REQUIRED_VERSION](#REQUIRED_VERSION) 的工作方式与 [PREFERRED_VERSION](#PREFERRED_VERSION) 完全相同，但如果指定的版本不可用，则会显示错误信息并立即导致编译失败。

如果同一配方同时设置了 [REQUIRED_VERSION](#REQUIRED_VERSION) 和  [PREFERRED_VERSION](#PREFERRED_VERSION)，则使用 [REQUIRED_VERSION](#REQUIRED_VERSION) 值。

## DEFAULT_PREFERENCE

指定配方选择优先级的弱偏差。

该变量最常见的用法是在软件开发版本的配方中将其设置为"-1"。在没有使用 PREFERRED_VERSION 构建开发版本的情况下，使用该变量会导致默认构建稳定版本的配方。

**备注**：[DEFAULT_PREFERENCE](#DEFAULT_PREFERENCE) 提供的偏置是弱偏置，如果包含相同配方不同版本的两个层之间的变量不同，该偏置会被 [BBFILE_PRIORITY](#BBFILE_PRIORITY) 覆盖。

## BBFILE_PRIORITY

为各层中的配方文件指定优先级。

当同一配方出现在多个图层中时，该变量非常有用。设置该变量后，您就可以根据包含相同配方的其他层来确定一个层的优先级，从而有效控制多个层的优先级。无论配方的版本（[PV](#PV) 变量）如何，通过该变量确定的优先级都是有效的。例如，一个层的配方 [PV](#PV) 值较高，但 [BBFILE_PRIORITY](#BBFILE_PRIORITY) 设置为较低优先级，该层的优先级仍然较低。

[BBFILE_PRIORITY](#BBFILE_PRIORITY) 变量的值越大，优先级越高。例如，值 6 的优先级高于值 5。如果没有指定，[BBFILE_PRIORITY](#BBFILE_PRIORITY) 变量将根据层依赖关系来设置（更多信息请参阅 [LAYERDEPENDS](#LAYERDEPENDS) 变量）。对于没有依赖关系的层，如果未指定，默认优先级为已定义的最低优先级 + 1（如果未定义优先级，则为 1）。

## LAYERDEPENDS

列出该配方所依赖的图层，以空格分隔。您也可以在层名末尾加上冒号，为依赖关系指定特定的层版本（例如，"anotherlayer:3 "将与本例中的 [LAYERVERSION](#LAYERVERSION)_anotherlayer 进行比较）。如果缺少任何依赖项或版本号不完全匹配（如果指定），BitBake 将产生错误。

该变量在 conf/layer.conf 文件中使用。您还必须使用特定层的名称作为变量的后缀（例如 LAYERDEPENDS_mylayer）。

## LAYERVERSION

以单个数字形式指定图层的版本。您可以在另一个图层的 [LAYERDEPENDS](#LAYERDEPENDS) 中使用该变量，以便依赖于该图层的特定版本。

您可以在 conf/layer.conf 文件中使用此变量。您还必须使用特定层的名称作为变量的后缀（如 LAYERDEPENDS_mylayer）。

## PACKAGES

配方创建的软件包列表。

## BB_SETSCENE_DEPVALID

指定 BitBake 调用的函数，用于确定 BitBake 是否需要满足 setscene 依赖性。

运行场景任务时，BitBake 需要知道该场景任务的哪些依赖项也需要运行。依赖项是否也需要运行在很大程度上取决于元数据。该变量指定的函数会根据是否需要满足依赖关系返回 "True" 或 "False"。

## BB_HASHCHECK_FUNCTION

指定在执行任务的 "setscene" 部分时调用的函数名称，以验证任务哈希值列表。该函数将返回应执行的 setscene 任务列表。

在代码执行的这一阶段，我们的目标是快速验证给定的 setscene 函数是否可能起作用。一次性检查 setscene 函数列表比调用许多单独的任务要容易得多。返回的列表不一定完全准确。给定的 setscene 任务稍后仍有可能失败。不过，返回的数据越准确，构建效率就越高。

## BB_BASEHASH_IGNORE_VARS

列出不包括在校验和依赖性数据中的变量。因此，被排除在外的变量可以在不影响校验和机制的情况下进行更改。一个常见的例子就是编译路径变量。BitBake 的输出不应（通常也不会）依赖于联编的目录。

## BB_SIGNATURE_HANDLER

定义 BitBake 使用的签名处理程序的名称。签名处理程序定义了创建和处理印章文件的方式、签名是否和如何纳入印章，以及签名本身的生成方式。

在全局命名空间中注入一个从 SignatureGenerator 类派生的类，即可添加新的签名处理程序。

## BB_TASKHASH

在执行中的任务中，该变量保存当前启用的签名生成器返回的任务哈希值。

## BB_SCHEDULER

选择用于 BitBake 任务调度的调度程序名称。有三个选项：

- basic - 基本框架，一切都源于此。使用该选项会导致任务在解析时按数字排序。


- speed - 优先执行依赖于更多任务的任务。速度 "选项是默认选项。

- completion - 一旦开始构建，调度程序就会尝试完成指定配方。

## BB_SCHEDULERS

定义要导入的自定义调度程序。自定义调度程序需要从 RunQueueScheduler 类派生。

有关如何选择调度程序的信息，请参阅 [BB_SCHEDULER](#BB_SCHEDULER) 变量。

## STAMP

指定用于创建配方图章文件的基本路径。实际印章文件的路径是通过评估该字符串并添加附加信息构建的。

## STAMPCLEAN

指定用于创建配方印记文件的基本路径。与 [STAMP]((#STAMP)) 变量不同，[STAMPCLEAN]((#STAMPCLEAN)) 可以包含通配符，以匹配清理操作应删除的文件范围。BitBake 在创建新图章时，会使用清除操作移除任何其他应移除的图章。

## T

指向 BitBake 在构建特定配方时放置临时文件的目录，临时文件主要包括任务日志和脚本。

## TOPDIR

指向构建目录。BitBake 会自动设置此变量。