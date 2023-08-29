# 2 设置使用 Yocto 项目

## 2.4 克隆和签出分支

### 2.4.1 克隆 poky 仓库

按照以下步骤创建本地版本的上游 Poky Git 仓库。

### 2.4.2 迁出 poky 分支

克隆上游 poky 仓库时，您可以访问其所有开发分支。版本库中的每个开发分支都是唯一的，因为它是从 "主 "分支分叉出来的。要在本地查看和使用某个开发分支的文件，你需要知道该分支的名称，然后专门查看该开发分支。

备注：通过分支名称签出活动开发分支，可获得签出时该分支的快照。在签出分支后，可以在该分支的基础上进行进一步开发。

#### 1st 切换到 Poky 目录

如果你有本地 poky Git 仓库，请切换到该目录。如果本地没有 poky，请参阅 "[克隆 poky 仓库](#2.4.1 克隆 poky 仓库)" 部分。

#### 2nd 确定现有分支名称

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

#### 3rd 查看分支

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





# 3 理解并创建图层

## 3.8 使用 bitbake-layers 脚本创建常规图层

# 4 源目录结构

## 4.1 顶级核心组件

### 4.1.10 oe-init-build-env