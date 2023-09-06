# 1 安装指定版本的 gcc

## 1.1 说明

此处特指在 ubuntu18 下折腾的情况。ubuntu18 自带的 gcc 为 7.5 版本，无法支持 c++17，无法满足 vim 插件 YCM 的编译。我们需要对其做升级。要求 gcc 以及 g++ 的版本至少为 8.0。第一种方式为官网下载然后编译、安装、使用，此方法坑太多，不建议使用。直接使用命令行安装更新即可。

## 1.2 安装

- 1st 删除旧版本

    ```bash
    sudo apt-get remove gcc g++
    ```

- 2nd 使用命令行安装，此处你可以使用 Tab 键来补充指定的 gcc 以及 g++ 版本，亲测是 8.4 版本，满足要求。

    ```bash
    sudo apt install gcc-x
    ```

    ```
    sudo apt install gcc+x
    ```

- 2nd 配置新版本全局可用

    - 链接 gcc

        ```bash
        sudo ln -s /usr/bin/gcc-8 /usr/bin/gcc
        ```

    - 链接 g++

        ```bash
        sudo ln -s /usr/bin/g++-8 /usr/bin/g++
        ```

# 2 安装指定版本的 cmake

## 2.1 下载地址

官网全版本资源下载地址：[cmake官网全版本资源下载](https://cmake.org/download/)

## 2.2 安装过程

- 1st 查看当前版本

    ```bash
    cmake --version
    ```

- 2nd 下载指定 cmake 源码至自定义目录

    ```bash
    wget https://cmake.org/download/
    ```

- 3rd 解压源码至指定目录（此处为 ~/tools）

    ```bash
    tar -c ~/tools -zxvf cmake-3.15.0-rc4.tar.gz
    ```

- 4th 编译安装

    - 进入源码根目录

        ```bash
        cd ~/tools/cmake-3.15.0-rc4
        ```

    - 执行配置

        ```bash
        ./bootstrap
        ```

    - 执行编译`make`

    - 执行安装

        ```bash
        sudo make install
        ```

    - 配置环境变量

        ```bash
        source ~/.bashrc
        ```

- 5th 验证

    ```bash
    cmake --version
    ```







# 3 安装指定版本 python

## 3.1 源码下载

- 官网版本下载地址（全版本）：[python官网版本下载](https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz)
- 个人维护版本（3.10）：[python3.10个人维护版本下载](https://zyb-tools.oss-cn-chengdu.aliyuncs.com/ubuntu-software/Python-3.10.0.tgz?OSSAccessKeyId=LTAI5tREkNKGRcMiPdgNQUye&Expires=3678160358&Signature=mvvAqI%2BoaxH3byjQdbrbv2ZqBWE%3D)

## 3.2 编译源码

- 1st 确认编译器及其中已经安装了 gcc（>8.0版本） 以及 cmake（>3.15版本）。

- 2nd 解压下载后的源码至自定义目录，本文以 ~/software 为例。

    ```bash
    tar -C ~/software/ -zxvf Python-3.10.0.tgz
    ```

- 3rd 安装必备工具

    ```bash
    sudo apt update
    sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev wget
    ```

- 4th 进入源码根目录 ~/software/Python-3.10.0 打配置

    ```bash
    ./configure xxx
    ```

    - xxx = "**--enable-shared**" 仅用这个配置即可，因为需要动态库，此正好满足
    - xxx = "**--enable-optimiza**" 编译完成之后安装完毕是静态库，无法编译 YCM

- 6th 在源码根目录 ~/software/Python-3.10.0 下执行编译

    ```bash
    make -j${nproc}
    ```

- 7th 在源码根目录 ~/software/Python-3.10.0 下执行安装指令

    ```bash
    sudo make install
    ```

- 8th 在源码根目录 ~/software/Python-3.10.0 下执行更新动态链接库缓存

    ```bash
    sudo ldconfig
    ```

    

## 3.3 安装

- 1st 源码跟目录 ~/tools/Python-3.10.0 下执行安装指令安装 python

    ```bash
    sudo make install
    ```

## 3.4 链接

使用命令行安装的文件其可执行链接位于 /usr/bin/ 目录下，包括日常执行的所有命令。但本地编译并安装的 python3.10，其可执行文件位于 /usr/local/bin 目录下。ubuntu18 折腾起来贼恶心，使用`sudo apt-get install python3`得到的 python3 实际上为 python3.6，千万不要把这个 python3 的链接给删了，否则会影响到整个 ubuntu18 的方方面面，比如你按 ctrl+alt+t 唤不醒终端。

- 1st 获取 python3 的安装路径

    ```bash
    which python3.10
    	==>/usr/local/bin/python3.10				// 安装路径打印 
    ```

- 2nd 建立新链接至 /usr/local/bin 目录

    ```bash
    sudo ln -s /usr/local/bin/python3.10 /usr/bin/python3.10
    ```

## 3.5 更新 pip 默认指向

- 1st 查看 pip 安装位置

    ```bash
    which pip3
    	==> /usr/local/bin/pip3
    ```

- 2nd 创建软连接

    ```bash
    sudo ln -s /usr/local/bin/pip3 /usr/bin/pip
    ```

# 4 安装指定版本 vim

## 4.1 说明

ubuntu18 下要想配置 vim，那么最好 vim 版本必须在 8.0+ 之后，亲测 8.0 不行。我们直接安装最新款的 vim 即可。

## 4.2 安装

- 1st 添加一个包含最新Vim版本的软件源

    ```bash
    sudo add-apt-repository ppa:jonathonf/vim
    ```

- 2nd 更新软件包列表

    ```bash
    sudo apt update
    ```

- 3rd 执行安装指令

    ```bash
    sudo apt install vim
    ```

    
