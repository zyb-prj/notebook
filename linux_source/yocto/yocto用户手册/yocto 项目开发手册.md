# 2_设置使用Yocto项目

## 2-4_克隆和签出分支

### 2-4-1_克隆poky仓库

按照以下步骤创建本地版本的上游 [Poky](https://github.com/zyb-prj/notebook/blob/main/linux_source/yocto/yocto%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C/yocto%20%E9%A1%B9%E7%9B%AE%E5%8F%82%E8%80%83%E6%89%8B%E5%86%8C.md#poky) Git 仓库。

#### 1st_设置您的目录

将工作目录更改为创建本地 poky 副本的位置。

#### 2nd_克隆存储库

下面的示例命令克隆了 poky 仓库，并使用默认名称 "poky "作为本地仓库的名称：

```bash
$ git clone git://git.yoctoproject.org/poky
Cloning into 'poky'...
remote: Counting objects: 432160, done.
remote: Compressing objects: 100% (102056/102056), done.
remote: Total 432160 (delta 323116), reused 432037 (delta 323000)
Receiving objects: 100% (432160/432160), 153.81 MiB | 8.54 MiB/s, done.
Resolving deltas: 100% (323116/323116), done.
Checking connectivity... done.
```

除非你指定了特定的开发分支或标记名，否则 Git 会克隆 "master "分支，从而产生 "master "的最新开发变更快照。关于如何签出特定的开发分支，或如何根据标签名签出本地分支，请分别参阅 "[在 Poky 中按分支签出](#2-4-2_在Poky中按分支签出)" 和 "[在 Poky 中按标签签出](#2-4-3_在Poky中按标签签出)" 章节。

### 2-4-2_在Poky中按分支签出

克隆上游 poky 仓库时，您可以访问其所有开发分支。版本库中的每个开发分支都是唯一的，因为它是从 "主 "分支分叉出来的。要在本地查看和使用某个开发分支的文件，你需要知道该分支的名称，然后专门查看该开发分支。

备注：通过分支名称签出活动开发分支，可获得签出时该分支的快照。在签出分支后，可以在该分支的基础上进行进一步开发。

#### 1st_切换到Poky目录

如果你有本地 poky Git 仓库，请切换到该目录。如果本地没有 poky，请参阅 "[克隆 poky 仓库](#2-4-1_克隆poky仓库)" 部分。

#### 2nd_确定现有分支名称

```bash
$ git branch -a
* master
remotes/origin/1.1_M1
remotes/origin/1.1_M2
remotes/origin/1.1_M3
remotes/origin/1.1_M4
remotes/origin/1.2_M1
remotes/origin/1.2_M2
remotes/origin/1.2_M3
. . .
remotes/origin/thud
remotes/origin/thud-next
remotes/origin/warrior
remotes/origin/warrior-next
remotes/origin/zeus
remotes/origin/zeus-next
... and so on ...
```

#### 3rd_查看分支

查看你要使用的开发分支。例如，要访问 Yocto Project 4.2.999 版本（Mickledore）的文件，请使用以下命令：

```bash
git checkout -b mickledore origin/mickledore

Note:
Branch mickledore set up to track remote branch mickledore from origin.
Switched to a new branch 'mickledore'
```

上一条命令检查了 "mickledore" 开发分支，并报告该分支正在跟踪上游的 "origin/mickledore" 分支。

下面的命令会显示现在属于本地 poky 代码库的分支。星号表示当前已签出工作的分支：

```bash
$ git branch
  master
  * mickledore
```

### 2-4-3_在Poky中按标签签出

与分支类似，上游版本库也使用标签来标记与开发分支中的重要点（即发布点或发布阶段）相关的特定提交。你可能想根据版本库中的这些点建立一个本地分支。除了使用标签名称外，这个过程与按分支名称签出类似。

备注：根据标签签出分支，可获得不受标签上分支开发影响的稳定文件集。

#### 1st_切换到Poky目录

如果你有本地 poky Git 仓库，请切换到该目录。如果本地没有 poky，请参阅 "[克隆 poky 仓库](#2-4-1_克隆poky仓库)" 部分。

#### 2nd_获取标签名称

要根据标签名称签出分支，需要在本地版本库中获取上游标签：

```bash
git fetch --tags
```

#### 3rd_列出标签名称

现在可以列出标签名称了：

```bash
$ git tag
1.1_M1.final
1.1_M1.rc1
1.1_M1.rc2
1.1_M2.final
1.1_M2.rc1
   .
   .
   .
yocto-2.5
yocto-2.5.1
yocto-2.5.2
yocto-2.5.3
yocto-2.6
yocto-2.6.1
yocto-2.6.2
yocto-2.7
yocto_1.5_M5.rc8
```

#### 4th_查看分支

```bash
$ git checkout tags/yocto-4.2.999 -b my_yocto_4.2.999
Switched to a new branch 'my_yocto_4.2.999'
$ git branch
  master
* my_yocto_4.2.999
```

上一条命令创建并签出了一个名为 "my_yocto_4.2.999" 的本地分支，该分支基于上游 poky 代码库中具有相同标签的提交。在本例中，通过签出命令获得的本地文件是 Yocto Project 4.2.999 发布时 "mickledore" 开发分支的快照。



# 3_理解并创建图层

## 3-8_使用bitbake-layers脚本创建常规图层

# 4_源目录结构

## 4-1_顶级核心组件

### 4-1-10_oe-init-build-env