

# 1 基本要求

当前阶段，ubuntu18 LTS 依旧为主力。使用 vim 需要各种插件，在配置文件中设置的插件更新也会默认获取最新版。比如代码自动补全插件 YouCompleteMe 就需要至少 python3.8+，对 vim 版本的要求也是 8.0+（亲自踩坑 8.0 不行）。

官网安装的 ubuntu18 LTS 默认自带 python3.6，同时使用`sudo apt-get install vim` 安装的 vim 版本是 8.0。在后续安装插件时会各种报错，因此我们需要手动获取 python3.10 以及 vim9.0 源码，编译后再安装使用。



# 2 安装软件
若您使用 ubuntu18.04，则要安装相对较新的 gcc、cmake、python 以及 vim 再做下文配置。详情参考[安装指定版本软件](https://github.com/zyb-prj/notebook/blob/main/software_source/ubuntu%E5%AE%89%E8%A3%85%E6%8C%87%E5%AE%9A%E7%89%88%E6%9C%AC%E8%BD%AF%E4%BB%B6.md)。
若您使用 ubuntu22.04，则完全不需要折腾，直接往下开整即可。

# 3 配置 vim

## 3.1 安装插件管理工具 Vundle

这步是必须的，有插件管理器才能通过配置文件安装插件。

Vundle 插件可以在 .vimrc 中跟踪、管理和自动更新插件内容。 

- 1st 创建插件目录（关键，固定文件夹）

    - 跳转至用户根目录

        ```shell
        cd ~
        ```

    - 创建指定文件夹（固定格式，不要更改）

        ```shell
        mkdir .vim && cd .vim && mkdir bundle && cd bundle
        ```

- 2nd 在指定目录`~/.vim/bundle`中下载插件

    ```bash
    git clone https://github.com/VundleVim/Vundle.vim.git
    ```

## 3.2 添加配置 ~/.vimrc

-  新增 ～/.vimrc 文件并添加配置，内置各种插件，内容如下

    ```bash
    " ==============vim基本配置==============
    set nocompatible
    set backspace=indent,eol,start
    set guifont=Monospace\ 14
    set nu!             " 显示行号
    syntax enable
    syntax on
    colorscheme desert
    
    set autowrite   " 自动保存
    
    set foldmethod=marker
    set foldlevel=100  " 启动vim时不要自动折叠代码
    set textwidth=80
    set formatoptions+=t
    set cindent
    set smartindent
    set noerrorbells
    set showmatch
    set nobackup 
    set noswapfile
    " set cursorline
    
    " disable 
    " noremap <Up> <Nop>
    " noremap <Down> <Nop>
    " noremap <Left> <Nop>
    " noremap <Right> <Nop>
    
    " remap control + arrow key to select windows
    noremap <C-Down>  <C-W>j
    noremap <C-Up>    <C-W>k
    noremap <C-Left>  <C-W>h
    noremap <C-Right> <C-W>l
    noremap <C-J> <C-W>j
    noremap <C-K> <C-W>k
    noremap <C-H> <C-W>h
    noremap <C-L> <C-W>l
    
    " ==============Vundle插件管理==============
    " Vundle manage
    set nocompatible              " be iMproved, required
    filetype off                  " required
    
    " set the runtime path to include Vundle and initialize
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    
    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'Valloric/YouCompleteMe'
    Plugin 'scrooloose/nerdtree'
    Plugin 'majutsushi/tagbar' " Tag bar"
    Plugin 'Xuyuanp/nerdtree-git-plugin'
    Plugin 'jistr/vim-nerdtree-tabs'
    Plugin 'vim-airline/vim-airline' | Plugin 'vim-airline/vim-airline-themes' " Status line"
    Plugin 'jiangmiao/auto-pairs'
    Plugin 'mbbill/undotree'
    Plugin 'gdbmgr'
    Plugin 'scrooloose/nerdcommenter'
    Plugin 'Yggdroot/indentLine' " Indentation level"
    Plugin 'bling/vim-bufferline' " Buffer line"
    "Plugin 'kepbod/quick-scope' " Quick scope
    Plugin 'yianwillis/vimcdoc'
    Plugin 'nelstrom/vim-visual-star-search'
    Plugin 'ludovicchabant/vim-gutentags'
    Plugin 'w0rp/ale'
    Plugin 'mbbill/echofunc'
    Plugin 'Yggdroot/LeaderF', { 'do': './install.sh' }
    Plugin 'vim-scripts/taglist.vim'
    
    " All of your Plugins must be added before the following line
    call vundle#end()            " required
    filetype plugin indent on    " required
    
    
    " ==============YCM==============
    let g:ycm_server_python_interpreter='/usr/bin/python3'
    let g:ycm_global_ycm_extra_conf='~/.vim/.ycm_extra_conf.py'
    let g:ycm_confirm_extra_conf = 0
      " YCM 查找定义
    let mapleader=','
    nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
    nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
    nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
    let g:ycm_collect_identifiers_from_tags_files = 1
    
    " 语法关键字补全
    let g:ycm_seed_identifiers_with_syntax = 1
    
    set completeopt=menu,menuone   
    let g:ycm_add_preview_to_completeopt = 0  " 关闭函数原型提示
    
    let g:ycm_show_diagnostics_ui = 0 " 关闭诊断信息
    let g:ycm_server_log_level = 'info'
    let g:ycm_min_num_identifier_candidate_chars = 2  " 两个字符触发 补全
    let g:ycm_collect_identifiers_from_comments_and_strings = 1 " 收集
    let g:ycm_complete_in_strings=1
    
    " noremap <c-z> <NOP>
    " let g:ycm_key_invoke_completion = '<c-z>'   " YCM 里触发语义补全有一个快捷键
    " let g:ycm_max_num_candidates = 15  " 候选数量
    
    let g:ycm_semantic_triggers =  {
                            \ 'c,cpp,python,java,go': ['re!\w{2}'],
                            \ }
    
    
    " ===========gutentags=============
    " 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
    let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project', '.gitignore']
    
    " 添加ctags额外参数，会让tags文件变大
    " let g:gutentags_ctags_extra_args = ['--fields=+niazlS', '--extra=+q']
     let g:gutentags_ctags_extra_args = ['--fields=+lS']
    " let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
    " let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
    
    if isdirectory("kernel/") && isdirectory("mm/")
            let g:gutentags_file_list_command = 'find arch/arm/ mm/ kernel/ include/ init/ lib/'
    endif
    
    
    " =======echodoc 显示函数参数===========
    " ctags -R --fields=+lS .
    
    "======= NetRedTree=========
    "->NERDTree目录树插件---配置选项=====================================================         
    let g:NERDTreeDirArrowExpandable = '▸'  "目录图标                                                           
    let g:NERDTreeDirArrowCollapsible = '▾'
    "autocmd vimenter * NERDTree                "自动打开目录树
    "vim【无文件】也显示目录树 
    "vim打开目录文件也显示目录树？
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene     | endif
    "CRTL+N开关目录树
    map <C-n> :NERDTreeToggle<CR>
    "关闭最后一个文件，同时关闭目录树
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    "<-NERDTree目录树插件---配置选项===============================================================
    let NERDTreeWinSize=20
    "let NERDTreeShowLineNumbers=1
    let NERDTreeAutoCenter=1
    let NERDTreeShowBookmarks=1
    let g:winManagerWindowLayout='TagList'
    nmap wm :WMToggle<cr>
    
    " ======ALE静态语法检测========
    let g:ale_sign_column_always = 1
    let g:ale_sign_error = '✗'
    let g:ale_sign_warning = 'w'
    let g:ale_statusline_format = ['✗ %d', '⚡ %d', '✔ OK']
    let g:ale_echo_msg_format = '[%linter%] %code: %%s'
    let g:ale_lint_on_text_changed = 'normal'
    let g:ale_lint_on_insert_leave = 1
    "let g:airline#extensions#ale#enabled = 1
    let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
    let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
    let g:ale_c_cppcheck_options = ''
    let g:ale_cpp_cppcheck_options = ''
    
    " ========airline状态栏=========  
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_section_b = '%-0.10{getcwd()}'
    let g:airline_section_c = '%t'
    let g:airline#extensions#tagbar#enabled = 1
    let g:airline_section_y = ''
    
    "--------------------------------------------------------------------------------
    " cscope:建立数据库：cscope -Rbq；  F5 查找c符号； F6 查找字符串；   F7 查找函数定义； F8 查找函数谁调用了，
    "--------------------------------------------------------------------------------
    if has("cscope")
      set csprg=/usr/bin/cscope
      set csto=1
      set cst
      set nocsverb
      " add any database in current directory
      if filereadable("cscope.out")
          cs add cscope.out
      endif
      set csverb
    endif
    
    
    :set cscopequickfix=s-,c-,d-,i-,t-,e-
    
    nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>
    
    
    "nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    "F5 查找c符号； F6 查找字符串；   F7 查找函数定义； F8 查找函数谁调用了，
    nmap <silent> <F5> :cs find s <C-R>=expand("<cword>")<CR><CR> :botright copen<CR><CR> 
    nmap <silent> <F6> :cs find t <C-R>=expand("<cword>")<CR><CR> :botright copen<CR><CR>
    "nmap <silent> <F7> :cs find g <C-R>=expand("<cword>")<CR><CR> 
    nmap <silent> <F7> :cs find c <C-R>=expand("<cword>")<CR><CR> :botright copen<CR><CR>
    
    
     "--------------------------------------------------------------------------------
    "  自动加载ctags: ctags -R
    if filereadable("tags")
          set tags=tags
    endif
    
    "--------------------------------------------------------------------------------
    " global:建立数据库
    "--------------------------------------------------------------------------------
    if filereadable("GTAGS")
            set cscopetag
            set cscopeprg=gtags-cscope
            cs add GTAGS
            au BufWritePost *.c,*.cpp,*.h silent! !global -u &
    endif
    
    " Tagbar
    let g:tagbar_width=25
    autocmd BufReadPost *.cpp,*.c,*.h,*.cc,*.cpp,*.cxx call tagbar#autoopen()
    
    "->taglist浏览插件配置=========================================
    "taglist窗口显示在右侧，缺省为左侧
    let Tlist_Use_Right_Window=1
    "设置ctags路径"将taglist与ctags关联
    let Tlist_Ctags_Cmd = '/usr/bin/ctags'
    "启动vim后自动打开taglist窗口
    let Tlist_Auto_Open = 1
    "不同时显示多个文件的tag，只显示当前文件的
    "不同时显示多个文件的tag，仅显示一个
    let Tlist_Show_One_File = 1
    "taglist为最后一个窗口时，退出vim
    let Tlist_Exit_OnlyWindow = 1
    "let Tlist_Use_Right_Window =1
    "设置taglist窗口大小
    "let Tlist_WinHeight = 100
    "let Tlist_WinWidth = 40
    "设置taglist打开关闭的快捷键F8
    noremap <F8> :TlistToggle<CR>
    "更新ctags标签文件快捷键设置
    noremap <F6> :!ctags -R<CR>
    "<-taglist=========================================
    ```

    注意第78行，python软连接根据个人设置操作。

## 3.3 安装插件

**基础条件：**

- 已经安装 8.0+ 版本的 vim
- 已经安装 3.6+ 版本的 python 并链接至 python3
- 已经安装 cmake make git

### 3.3.1 通过插件安装 ~/.vimrc 中配置的各类插件

 启动 vim，进入命令行模式之后，输入`PluginInstall`按回车即可自动下载并安装插件（其它插件亦是如此）。

#### 安装大纲生成插件 Tagbar

- 作用：用源代码文件生成大纲，包括类、方法、变量以及函数名等，可以选中并快速跳转到目标位置。
- 安装插件配置详情见[.vimrc 内容](https://github.com/zyb-prj/notebook/blob/main/vim%20%E6%A8%A1%E5%9D%97/.vimrc)第 53 行，打开 vim 使用`:PluginInstall`指令安装插件。
- 为了方便使用，使 vim 打开源码自动生成列表，需要做自动化配置，详情见[.vimrc 内容](https://github.com/zyb-prj/notebook/blob/main/vim%20%E6%A8%A1%E5%9D%97/.vimrc)第 221~223 行。

#### 安装文件浏览插件 NerdTree

- 作用：显示树状目录。
- 安装插件配置详情见[.vimrc 内容](https://github.com/zyb-prj/notebook/blob/main/vim%20%E6%A8%A1%E5%9D%97/.vimrc)第 54 行，打开 vim 使用`:PluginInstall`指令安装插件。
- 为了方便使用，需要做自定义配置，配置详情见[.vimrc 内容](https://github.com/zyb-prj/notebook/blob/main/vim%20%E6%A8%A1%E5%9D%97/.vimrc)第 127～146 行。

#### 安装动态语法检测工具

- 作用：编辑代码过程中检测出语法错误，不用等到编译或者运行。光标移动在当前行会显示错误原因。
- 安装插件配置详情见[.vimrc 内容](https://github.com/zyb-prj/notebook/blob/main/vim%20%E6%A8%A1%E5%9D%97/.vimrc)第 67 行，打开 vim 使用`:PluginInstall`指令安装插件。
- 为了方便使用，使 vim 任意时刻均提示错误，需要做自动化配置，详情见[.vimrc 内容](https://github.com/zyb-prj/notebook/blob/main/vim%20%E6%A8%A1%E5%9D%97/.vimrc)第 148~160 行。

#### 安装自动索引插件 vim-gutentags

- 作用：异步生成 tags 索引。
- 安装插件配置详情见[.vimrc 内容](https://github.com/zyb-prj/notebook/blob/main/vim%20%E6%A8%A1%E5%9D%97/.vimrc)第 66 行，打开 vim 使用`:PluginInstall`指令安装插件。
- 为了方便使用，当我们修改一个文件时，vim-gutentags 会在后台帮助我们更新 tags 数据索引库。需要做自定义配置，配置详情见[.vimrc 内容](https://github.com/zyb-prj/notebook/blob/main/vim%20%E6%A8%A1%E5%9D%97/.vimrc)第 109～121 行。

### 3.3.2  安装自动补全插件 YouCompleteMe

YouCompleteMe 插件比较奇葩，需要拉取最新的做编译并将产物复制到指定位置。

#### 插件安装

- 作用：YCM 插件的作用是编辑代码自动补全。
- 安装插件配置详情见[.vimrc 内容](https://github.com/zyb-prj/notebook/blob/main/vim%20%E6%A8%A1%E5%9D%97/.vimrc)第 51 行，打开 vim 使用`:PluginInstall`指令安装插件。
- 安装完成效果是在`~/.vim/bundle/`目录下安装了 YCM 源码，但是 YCM 无法使用，需要重新编译并将产物配置复制到 ~/.vim 目录下做配置后重新使用`:PluginInstall`指令安装插件。

#### 插件配置

- 1st 必备软件安装

    ```bash
    sudo apt-get install build-essential cmake python3-dev
    ```

- 2nd 进入 YCM 源码根目录 ~/.vim/bundle/YouCompleteMe，拉取最新代码

    ```bash
    git submodule update --init --recursive
    ```

- 3rd 在 YCM 源码根目录编译源码

    ```bash
    python3 install.py --clang-completer
    ```

    - --clang-completer 表示对 C/C++ 提供支持。

- 4th 配置工作，将 YCM 源码根目录编译产物放至 ~/.vim 下。

    ```bash
    cp third_party/ycmd/examples/.ycm_extra_conf.py ~/.vim
    ```

    

- 5th 确保 ~/.vimrc 文件下有如下配置

    ```bash
    let g:ycm_server_python_interpreter='/usr/bin/python3'
    let g:ycm_global_ycm_extra_conf='~/.vim/.ycm_extra_conf.py'
    ```

    - 其中，第 1 行的 python3 需要根据自定义配置随机变更，否则会出现加载失败的现象。

- 6th 使用`:PluginInstall`指令重新安装插件。

为了方便使用，做自动化配置使得 vim 在任一时刻编辑都会产生自动补全的效果，配置详情见[.vimrc 内容](https://github.com/zyb-prj/notebook/blob/main/vim%20%E6%A8%A1%E5%9D%97/.vimrc)第 77～106 行。

### 3.3.3 其它工具安装

#### 安装跳转工具 ctags

- 作用：用于扫描指定的源文件，找出其中包含的语法元素，并把找到的相关内容记录下来，这样在浏览和查找代码时就可以利用这些记录实现查找和跳转功能。

- 安装

    ```bash
    sudo apt-get install universal-ctags
    ```

- 使用

    - 在使用 ctags 工具之前需要手动生成索引文件，在需要 vim 打开的源码跟目录下执行如下指令，指令如下：

        ```bash
        ctags -R .
        ```

    - 上述指令会在当前目录下生成一个 tags 文件。启动 vim 之后需要加载这个 tags 文件，**vim 中使用如下指令实现加载**：

        ```bash
        :set tags=tags
        ```

    - 为了方便使用，在 .vimrc 中已经做了配置，详情见[.vimrc 内容](https://github.com/zyb-prj/notebook/blob/main/vim%20%E6%A8%A1%E5%9D%97/.vimrc)第 205～209 行。

- 常用快捷键

    |  快捷键  |                用法                |
    | :------: | :--------------------------------: |
    | Ctrl + ] | 跳转到光标处的函数或变量定义的位置 |
    | Ctrl + T |        返回到跳转之前的地方        |

#### 安装查询调用位置工具 cscope

- 作用：查找函数在哪里被调用。

- 安装

    ```bash
    sudo apt-get install cscope
    ```

- 使用

    - 在使用 scope 工具之前需要为源码生成索引库，指令如下（在源码根目录下执行）：

        ```bash
        cscope -Rbq
        ```

    - 上述指令会生成 3 个文件，cscope.cout、scope.in.out 和 scope.po.out。其中 scosse.cout 是基本索引，后面两个文件是是使用`-q`选项生成的，用于加快 scope 索引加快速度。

    - 在 .vimrc 中已经做了配置，详情见[.vimrc 内容](https://github.com/zyb-prj/notebook/blob/main/vim%20%E6%A8%A1%E5%9D%97/.vimrc)第 169～202 行，生成 3 条快捷指令

        | 快捷键 |           功能           |
        | :----: | :----------------------: |
        |   F5   |     查找 C 语言符号      |
        |   F6   |      查找指定字符串      |
        |   F7   | 查找哪些函数调用了本函数 |

# 4 使用 vim 阅读 Linux 内核源代码

TODO:

- 笨叔叔内核：git clone https://github.com/runninglinuxkernel/runninglinuxkernel_5.0
- Ti-蓝洋内核：