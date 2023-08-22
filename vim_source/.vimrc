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