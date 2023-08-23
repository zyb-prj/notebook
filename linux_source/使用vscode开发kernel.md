# 1 软件安装

## 1.1 基础软件安装

- 安装并配置 git：参考[自定义git配置](https://github.com/zyb-prj/notebook/blob/main/git_source/%E8%87%AA%E5%AE%9A%E4%B9%89%E9%85%8D%E7%BD%AEgit.md)


- 安装 bear

    ```bash
    sudo apt install bear
    ```

- 客户端/服务端均安装 vscode，详情参考[安装vscode](https://github.com/zyb-prj/notebook/blob/main/software_source/ubuntu%E5%AE%89%E8%A3%85%E5%B8%B8%E7%94%A8%E8%BD%AF%E4%BB%B6.md#34-%E5%AE%89%E8%A3%85-vscode)

## 1.2 vscode 插件安装

- 客户端/服务端均安装。
- 客户端必须安装（后续可使用 ssh 连接至服务端再同步至服务端）。

### 1.2.1 插件目录

- c 技术栈类：`C/C++`    `C/C++ Extension Pack`    `C/C++ Snippets`    `Clangd`     `Code Runner`  


- linux 开发工具类：`Remote SSH`    `DeviceTree`    `Arm Assembly`    `Hex Editor`


- 软件开发工具类：`Code Spell Checker`     `compareit`    `Tabnine AI Autocomplete` 


​									`Bracket Pair Colorization Toggler` 

- 辅助开发工具类：`Chinese`     `vscode-icons`    `One Dark Pro`


​                                     `Rainbow Highlighter` ： 高亮文字：shift + alt + z     取消高亮：shift + alt + a            

- markdown类：`Markdown All in One`    `Markdown Preview Enhanced`

### 1.2.2 插件确认

如下图 1-1 所示。

![vscode开发kernel所需插件](https://zyb-note-pic.oss-cn-chengdu.aliyuncs.com/linux-source/%E4%BD%BF%E7%94%A8vscode%E5%BC%80%E5%8F%91kernel/1-1_vscode%E5%BC%80%E5%8F%91kernel%E6%89%80%E9%9C%80%E6%8F%92%E4%BB%B6.png?OSSAccessKeyId=LTAI5tREkNKGRcMiPdgNQUye&Expires=10000000001692758000&Signature=FGlVUvnSHMEGiaG4NE15evJdpBA%3D)

## 1.3 安装 clangd

vscode 安装 clang 插件后，它的使用还需要一个运行在 Linux 服务器上的 clangd 程序。我们以后使用 vscode 打开 C 文件时，会提示你安装 clangd 程序，它会安装最新版本(版本15)，但是这个版本有一些 Bug，所以我们手工安装版本13。

### 1.3.1 下载源

- 官方下载地址：[Clang13.0官方版本下载](https://github.com/clangd/clangd/releases/tag/13.0.0)
- 个人维护版本：[Clang13.0个人维护版本下载](https://zyb-tools.oss-cn-chengdu.aliyuncs.com/ubuntu-software/clangd-linux-13.0.0.zip?OSSAccessKeyId=LTAI5tREkNKGRcMiPdgNQUye&Expires=3677989892&Signature=ERMepUJIgij9Yc%2BLKfUzH5xHbxs%3D)

### 1.3.2 下载并安装（一定要在服务端安装）

- 1st 需要安装 clang 插件

- 2nd 下载 clang13.0 版本至指定目录

- 3rd 把下载到的 clangd-linux-13.0.0.zip 放到指定目录下，此处为 ~/software

    ```bash
    unzip -d ~/software clangd-linux-13.0.0.zip
    ```

# 2 使用 vscode 远程连接

## 2.1 说明

- 确保 ubuntu 服务端安装了 ssh 以及 net-tools，安装方式参考[常见嵌入式开发工具套装](https://github.com/zyb-prj/notebook/blob/main/software_source/ubuntu%E5%AE%89%E8%A3%85%E5%B8%B8%E7%94%A8%E8%BD%AF%E4%BB%B6.md#21-%E5%B8%B8%E8%A7%81%E5%B5%8C%E5%85%A5%E5%BC%8F%E5%BC%80%E5%8F%91%E5%B7%A5%E5%85%B7%E5%A5%97%E8%A3%85)。
- 确保 ubuntu 服务端 ubuntu 下的 vscode 安装了`Remote SSH`插件，同时客户端的 vscode 也安装了`Remote SSH`插件。

- linux 内核开发建议使用 ubuntu 操作系统来做开发，下面我们称其为服务端。同时 windows 或 mac 操作系统更具有可操作性，下面称其为客户端，因此我们可以在 win 或 mac 下使用 vscode 远程连接服务器来做开发。

## 2.2 ssh 连接

- 1st 获取服务端 IP，假设为 xx.xx.xx.x。

- 2nd 打开服务端 vscode，点击左下角的远程连接按钮，操作流程如下图 2-1 所示。

    ![vscode通过左下角远程连接按钮操作流程界面](https://zyb-note-pic.oss-cn-chengdu.aliyuncs.com/linux-source/%E4%BD%BF%E7%94%A8vscode%E5%BC%80%E5%8F%91kernel/2-1_vscode%E9%80%9A%E8%BF%87%E5%B7%A6%E4%B8%8B%E8%A7%92%E8%BF%9C%E7%A8%8B%E8%BF%9E%E6%8E%A5%E6%8C%89%E9%92%AE%E6%93%8D%E4%BD%9C%E6%B5%81%E7%A8%8B%E7%95%8C%E9%9D%A2.png?OSSAccessKeyId=LTAI5tREkNKGRcMiPdgNQUye&Expires=10000000001692758000&Signature=KiwGcKFGxZ8Hy9a1sHE6rAYx%2B6k%3D)

- 3rd 新增连接，操作流程如下图 2-2 所示。

    ![vscode新增连接操作流程界面](https://zyb-note-pic.oss-cn-chengdu.aliyuncs.com/linux-source/%E4%BD%BF%E7%94%A8vscode%E5%BC%80%E5%8F%91kernel/2-2_vscode%E6%96%B0%E5%A2%9E%E8%BF%9E%E6%8E%A5%E6%93%8D%E4%BD%9C%E6%B5%81%E7%A8%8B%E7%95%8C%E9%9D%A2.png?OSSAccessKeyId=LTAI5tREkNKGRcMiPdgNQUye&Expires=10000000001692758000&Signature=fl%2B0qDosmt91y26%2BEJDRkrQTmTM%3D)

- 4th 按要求配置远程连接指令：`ssh user@xx.xxx.xxx.x -A`，输入完成后按回车确定。操作流程如下图 2-3 所示。

    ![vscode按要求配置ssh连接指令操作流程界面](https://zyb-note-pic.oss-cn-chengdu.aliyuncs.com/linux-source/%E4%BD%BF%E7%94%A8vscode%E5%BC%80%E5%8F%91kernel/2-3_vscode%E6%8C%89%E8%A6%81%E6%B1%82%E9%85%8D%E7%BD%AEssh%E8%BF%9E%E6%8E%A5%E6%8C%87%E4%BB%A4%E6%93%8D%E4%BD%9C%E6%B5%81%E7%A8%8B%E7%95%8C%E9%9D%A2.png?OSSAccessKeyId=LTAI5tREkNKGRcMiPdgNQUye&Expires=10000000001692758000&Signature=sWivdcm27tRdpGseNpy4R4QHe6g%3D)

- 5th 重新按照 1st & 2nd & 3rd 的方式走到 3rd 所示途中的位置会出现添加的配置，如下图 2-4 所示：

    ![vscode通过ssh连接最后一步操作界面流程](https://zyb-note-pic.oss-cn-chengdu.aliyuncs.com/linux-source/%E4%BD%BF%E7%94%A8vscode%E5%BC%80%E5%8F%91kernel/2-3_vscode%E6%8C%89%E8%A6%81%E6%B1%82%E9%85%8D%E7%BD%AEssh%E8%BF%9E%E6%8E%A5%E6%8C%87%E4%BB%A4%E6%93%8D%E4%BD%9C%E6%B5%81%E7%A8%8B%E7%95%8C%E9%9D%A2.png?OSSAccessKeyId=LTAI5tREkNKGRcMiPdgNQUye&Expires=10000000001692758000&Signature=sWivdcm27tRdpGseNpy4R4QHe6g%3D)


- 6th 连接之后一定要确保客户端和服务端的 vscode 安装同样的插件（极其重要），连接至服务端之后可以在客户端插件处操作安装至服务端，如下图 2-5 所示：


    ![vscode服务端插件安装操作流程界面](https://zyb-note-pic.oss-cn-chengdu.aliyuncs.com/linux-source/%E4%BD%BF%E7%94%A8vscode%E5%BC%80%E5%8F%91kernel/2-5_vscode%E6%9C%8D%E5%8A%A1%E7%AB%AF%E6%8F%92%E4%BB%B6%E5%AE%89%E8%A3%85%E6%93%8D%E4%BD%9C%E6%B5%81%E7%A8%8B%E7%95%8C%E9%9D%A2.png?OSSAccessKeyId=LTAI5tREkNKGRcMiPdgNQUye&Expires=10000000001692758000&Signature=pNIXyJyxLRJJ1YtjE2%2F6nk8jJ3w%3D)

## 2.3 服务端配置


- 1st 确保 clang13.0 插件完成安装（[clang13.0安装方式](https://github.com/zyb-prj/notebook/blob/main/linux_source/%E4%BD%BF%E7%94%A8vscode%E5%BC%80%E5%8F%91kernel.md#13-%E5%AE%89%E8%A3%85-clangd)），并获取其安装路径（此处为 ～/tools/clangd_13.0.0/bin）。


- 2nd 修改服务端设置文件，客户端 vscode 连接到服务端之后打开 vscode 服务器配置文件 settings.json 做适当调整。操作流程如下图 2-6 所示。

    ![2-6_修改settings.json操作流程界面](https://zyb-note-pic.oss-cn-chengdu.aliyuncs.com/linux-source/%E4%BD%BF%E7%94%A8vscode%E5%BC%80%E5%8F%91kernel/2-6_%E4%BF%AE%E6%94%B9settings.json%E6%93%8D%E4%BD%9C%E6%B5%81%E7%A8%8B%E7%95%8C%E9%9D%A2.png?OSSAccessKeyId=LTAI5tREkNKGRcMiPdgNQUye&Expires=10000000001692758000&Signature=vepNBvD3wwZF5EY6j%2FvgtPTAKgw%3D)

- #### 3rd settings.json 基本设置内容

    ```json
    {
    	"C_Cpp.default.intelliSenseMode": "linux-gcc-arm",
    	"C_Cpp.intelliSenseEngine": "Disabled",
    	"clangd.path": " /.../clangd_13.0.0/bin/clangd",
    	"clangd.arguments": [
    		"--log=verbose",
    	],
    }
    ```

