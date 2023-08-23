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

```
busybox_1.21.%.bbappend
```

该附加文件将匹配任何 busybox_1.21.x.bb 版本的配方。因此，该附加文件将匹配以下配方名称：

```
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

    ```bash
    git clone git://git.openembedded.org/bitbake
    ```

    该命令将 BitBake Git 仓库克隆到一个名为 bitbake 的目录中。或者，如果你想把新目录命名为 bitbake 以外的名字，也可以在 git clone 命令后指定一个目录。下面是一个命名为 bbdev 的例子：

    ```bash
    git clone git://git.openembedded.org/bitbake bbdev 
    ```

- **使用发行版软件包管理系统安装**：不建议使用这种方法，因为在大多数情况下，发行版提供的 BitBake 版本要比 BitBake 软件源快照晚几个版本。

- **获取 BitBake 的快照**：从源代码库下载 BitBake 的快照，即可访问 BitBake 的已知分支或版本。

    **备注**：如前所述，克隆 Git 仓库是获取 BitBake 的首选方法。当补丁添加到稳定分支时，克隆版本库更容易更新。

    - 下面的示例下载了 BitBake 1.17.0 版本的快照：

        ```bash
        wget https://git.openembedded.org/bitbake/snapshot/bitbake-1.17.0.tar.gz
        ```

    - 使用 tar 工具提取 tar 包后，就会得到一个名为 bitbake-1.17.0 的目录：

        ```bash
        tar zxpvf bitbake-1.17.0.tar.gz
        ```

- **使用构建目录时附带的 BitBake**：获得 BitBake 副本的最后一种可能性是，它已随基于 BitBake 的大型构建系统（如 Poky）一起签出。与手动签出单个层并将它们粘合在一起相比，你可以签出整个构建系统。签出的 BitBake 版本已经与其他组件进行了全面的兼容性测试。有关如何检出基于 BitBake 的特定构建系统的信息，请查阅该构建系统的支持文档。

## 1.5 BitBake 命令

bitbake 命令是 BitBake 工具的主要接口。本节将介绍 BitBake 命令的语法，并提供几个执行示例。

### 1.5.1 使用方法和语法

以下是 BitBake 的用法和语法：

```bash
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

```bash
bitbake -b foo_1.0.bb
```

以下命令在 foo.bb 配方文件上运行清理任务：

```bash
bitbake -b foo.bb -c clean
```

**备注**：-b 选项不明确处理配方依赖关系。除调试目的外，建议使用下一节介绍的语法。

#### 针对一组配方文件执行任务

如果要管理多个 .bb 文件，就会产生一些额外的复杂问题。显然，需要有一种方法来告诉 BitBake 有哪些文件可用，以及你想执行其中的哪些文件。此外，还需要有一种方法让每个配方都能在构建时和运行时表达其依赖关系。当多个配方提供相同的功能，或一个配方有多个版本时，必须有一种方法让你表达配方偏好。

如果不使用"-buildfile "或"-b"，bitbake 命令只接受 "PROVIDES"。您不能提供任何其他信息。默认情况下，配方文件一般会 "提供 "其 "packagename"，如下例所示：

```bash
bitbake foo
```

下一个示例 "PROVIDES "软件包名称，并使用"-c "选项告诉 BitBake 只执行 do_clean 任务：

```bash
bitbake -c clean foo
```

#### 执行任务和配方组合列表

当您指定多个目标时，BitBake 命令行支持为各个目标指定不同的任务。例如，假设您有两个目标（或配方）myfirstrecipe 和 mysecondrecipe，您需要 BitBake 为第一个配方运行任务 A，为第二个配方运行任务 B：

```bash
bitbake myfirstrecipe:do_taskA mysecondrecipe:do_taskB
```

#### 生成依赖关系图

BitBake 可以使用点语法生成依赖关系图。您可以使用 [Graphviz](https://www.graphviz.org/) 的 dot 工具将这些图形转换为图像。

生成依赖关系图时，BitBake 会向当前工作目录写入两个文件：

- task-depends.dot：显示任务之间的依赖关系。这些依赖关系与 BitBake 的内部任务执行列表相匹配。


- pn-buildlist：显示待构建目标的简单列表。

要停止依赖常见的依赖项，使用 -I depend 选项，BitBake 就会从图表中省略它们。省略这些信息可以生成更易读的图形。这样，你就可以从图形中删除继承类（如 base.bbclass）的 [DEPENDS](https://docs.yoctoproject.org/bitbake/bitbake-user-manual/bitbake-user-manual-ref-variables.html#term-DEPENDS)。

下面是创建依赖关系图的示例：

```
bitbake -g foo
```

下面示例将 OpenEmbedded 中常见的依赖关系从图中删除：

```
bitbake -g -I virtual/kernel -I eglibc foo
```

#### 执行多重配置构建

BitBake 可以使用一条命令构建多个映像或软件包，不同的目标需要不同的配置（多配置构建）。在这种情况下，每个目标都被称为 "多配置"。

要完成多重配置构建，必须在构建目录中使用并行配置文件分别定义每个目标的配置。这些 multiconfig 配置文件的位置是特定的。它们必须位于当前构建目录中名为 multiconfig 的 conf 子目录下。以下是两个独立目标的示例，如图 1-1 所示：

![1-1_执行多重配置构建之配置文件创建结构](https://zyb-note-pic.oss-cn-chengdu.aliyuncs.com/linux-source/yocto/bitbake%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/1-1_%E6%89%A7%E8%A1%8C%E5%A4%9A%E9%87%8D%E9%85%8D%E7%BD%AE%E6%9E%84%E5%BB%BA%E4%B9%8B%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E5%88%9B%E5%BB%BA%E7%BB%93%E6%9E%84.png?OSSAccessKeyId=LTAI5tREkNKGRcMiPdgNQUye&Expires=10000000001692772000&Signature=5Whc45p7MAhJVbkzfEaRgtXBaZs%3D)

之所以需要这样的文件层次结构，是因为 BBPATH 变量是在层解析之前构建的。因此，将配置文件作为预配置文件使用是不可能的，除非它位于当前工作目录下。

最低限度，每个配置文件都必须定义机器和 BitBake 用于编译的临时目录。建议的做法是在编译过程中不要重叠使用临时目录。

除了为每个目标分别创建配置文件外，还必须启用 BitBake 以执行多重配置构建。启用方法是在 local.conf 配置文件中设置 BBMULTICONFIG 变量。举个例子，假设你在构建目录中定义了 target1 和 target2 的配置文件。local.conf 文件中的以下语句既能让 BitBake 执行多重配置编译，又能指定两个额外的 multiconfigs：

```bash
BBMULTICONFIG = "target1 target2"
```

目标配置文件就绪并启用 BitBake 以执行多重配置编译后，使用以下命令启动编译：

```bash
bitbake [mc:multiconfigname:]target [[[mc:multiconfigname:]target] ... ]
```

Here is an example for two extra multiconfigs: `target1` and `target2`:

```bash
bitbake mc::target mc:target1:target mc:target2:target
```

#### 启用多重配置构建依赖关系

在多重配置构建过程中，目标（多图标）之间有时会存在依赖关系。例如，假设要为某一特定架构构建镜像，另一不同架构构建镜像的根文件系统必须存在。换句话说，第一个多重配置的镜像依赖于第二个多重配置的根文件系统。这种依赖关系的本质是，构建一个多重配置的配方中的任务依赖于构建另一个多重配置的配方中的任务的完成。

要在多重配置构建中启用依赖项，必须在配方中使用以下语句形式声明依赖项：

```bash
task_or_package[mcdepends] = "mc:from_multiconfig:to_multiconfig:recipe_name:task_on_which_to_depend"
```

为了更好地说明如何使用该语句，请看一个包含两个多重图标（target1 和 target2）的示例：

```bash
image_task[mcdepends] = "mc:target1:target2:image2:rootfs_task"
```

在本例中，from_multiconfig 为 "target1"，to_multiconfig 为 "target2"。包含 image_task 的映像任务取决于用于生成映像 2 的 rootfs_task 的完成情况，而映像 2 与 "target2 "multiconfig 相关联。



一旦设置了该依赖关系，就可以使用 BitBake 命令构建 "target1 "多参数配置，如下所示：

```bash
bitbake mc:target1:image1
```

该命令将执行为 "target1 "multiconfig 创建 image1 所需的所有任务。由于存在依赖关系，BitBake 也会通过 rootfs_task 执行 "target2 "multiconfig 的构建任务。



让一个配方依赖于另一个构建的根文件系统似乎并不那么有用。请考虑对 image1 配方中的语句作如下修改：

```bash
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







# 3 语法和运算符

## 3.4 共享功能

### 3.4.5 INHERIT 配置指令

创建配置文件（.conf）时，可以使用 [INHERIT](#INHERIT) 配置指令来继承一个类。BitBake 仅支持在配置文件中使用该指令。

举个例子，假设需要从配置文件中继承一个名为 abc.bbclass 的类文件，如下所示：

```bash
INHERIT += "abc"
```

在解析过程中，该配置指令会导致指定的类被继承。与继承指令一样，.bbclass 文件必须位于 [BBPATH](#BBPATH) 指定目录中的 "classes "子目录下。

**备注**：由于 .conf 文件在 BitBake 执行过程中首先被解析，因此使用 [INHERIT](#INHERIT) 继承一个类实际上是全局继承该类（即继承所有配方）。

如果要使用该指令继承多个类，可以在 local.conf 文件的同一行中提供。使用空格分隔类。下面的示例展示了如何同时继承 autotools 和 pkgconfig 两个类：

```bash
INHERIT += "autotools pkgconfig"
```



## 3.6 任务

### 3.6.3 向构建任务环境传递信息

在运行任务时，BitBake 会严格控制构建任务的 shell 执行环境，以确保来自构建机器的不必要污染不会影响构建。

**备注**：默认情况下，BitBake 会对环境进行清理，只包含导出或列在直通列表中的内容，以确保编译环境的可重复性和一致性。您可以通过设置 [BB_PRESERVE_ENV](#BB_PRESERVE_ENV) 变量来阻止这种 "清理"。

因此，如果您确实希望将某些内容传递到构建任务环境中，就必须采取这两个步骤：

1. 告诉 BitBake 从环境中加载您想要的内容到数据存储中。这可以通过 [BB_ENV_PASSTHROUGH](#BB_ENV_PASSTHROUGH) 和 [BB_ENV_PASSTHROUGH_ADDITIONS](#BB_ENV_PASSTHROUGH_ADDITIONS) 变量来实现。例如，假设你想阻止编译系统访问 $HOME/.ccache 目录。下面的命令将环境变量 CCACHE_DIR 添加到 BitBake 的直通列表中，以允许该变量进入数据存储：

    ```bash
    export BB_ENV_PASSTHROUGH_ADDITIONS="$BB_ENV_PASSTHROUGH_ADDITIONS CCACHE_DIR"
    ```

2. 告诉 BitBake 将加载到数据存储中的内容导出到每个运行任务的任务环境中。将环境中的内容加载到数据存储中（上一步）只能使其在数据存储中可用。要将其导出到每个运行任务的任务环境中，请在本地配置文件 local.conf 或发行版配置文件中使用类似下面的命令：

    ```bash
    export CCACHE_DIR
    ```

    **备注**：前面步骤的一个副作用是，BitBake 会将变量作为编译过程的依赖项记录到 setscene 校验和等文件中。如果这样做会导致不必要的任务重建，也可以标记变量，这样 setscene 代码在创建校验和时就会忽略该依赖关系。

有时，从原始执行环境中获取信息是非常有用的。BitBake 会将原始环境的副本保存到一个名为 [BB_ORIGENV](#BB_ORIGENV) 的特殊变量中。

[BB_ORIGENV](#BB_ORIGENV) 变量返回一个数据存储对象，可以使用标准数据存储操作符（如 getVar(,False)）进行查询。例如，数据存储对象在查找原始 DISPLAY 变量时非常有用。下面是一个示例：

```bash
origenv = d.getVar("BB_ORIGENV", False)
bar = origenv.getVar("BAR", False)
```

上例从原始执行环境返回 BAR。

# 5 变量词汇表

## BBPATH

BitBake 用来查找类（.bbclass）和配置（.conf）文件。该变量类似于 PATH 变量。

如果从联编目录之外的目录运行 BitBake，必须确保将 BBPATH 设为指向联编目录。像设置其他环境变量一样设置该变量，然后运行 BitBake：

```bash
BBPATH="build_directory"
export BBPATH
bitbake target
```

## BBFILES

以空格分隔的 BitBake 用来构建软件的配方文件列表。

指定配方文件时，可以使用 Python 的 glob 语法进行模式匹配。有关语法的详细信息，请点击前面的链接查看文档。

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