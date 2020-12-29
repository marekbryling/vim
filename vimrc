set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'frazrepo/vim-rainbow'

" NERDTree
Plugin 'preservim/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'ryanoasis/vim-devicons'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
" end NERDTree

Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'

Plugin 'itchyny/lightline.vim'

Plugin 'airblade/vim-gitgutter'

Plugin 'vim-syntastic/syntastic'

Plugin 'rust-lang/rust.vim'

Plugin 'majutsushi/tagbar'

Plugin 'myint/syntastic-extras'

Plugin 'psf/black'

" Plugin 'jmcantrell/vim-virtualenv'

Plugin 'davidhalter/jedi-vim'

Plugin 'deoplete-plugins/deoplete-jedi'

Plugin 'petobens/poet-v'

call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


" NERDTree config
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeNodeDelimiter = "\u00a0"

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" end NERDTree config

let g:rainbow_active = 1        " frazrepo/vim-rainbow activate
let g:gitgutter_git_executable='/usr/bin/git'

" start Syntastic config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" end Syntastic config

let g:rustfmt_autosave = 1

syntax enable
set encoding=utf-8
set fileencodings=utf-8         " domyślne kodowanie
set nocompatible                " niekompatybilny z VI => w??cz bajery VIMa
set nobackup                    " nie trzymaj kopii zapasowych, używaj wersji
set backspace=indent,eol,start
set viminfo='20,\"50            " read/write a .viminfo file, don't store more than 50 lines of registers
set history=50                  " keep 50 lines of command line history
set ruler                       " show the cursor position all the time
set showcmd                     " display incomplete commands
set autoindent                  " automatyczne wcięcia
set pastetoggle=<F11>           " przełączanie w tryb wklejania (nie będzie automatycznych wcięć, ...)
set number                      " pierwszy odpalony bufor ma numerki
set wildmenu                    " wyświetlaj linie z menu podczas dope?niania
set showmatch                   " pokaz otwieraj?cy nawias gdy wpisze zamykaj?cy
set so=5                        " przewijaj już na 5 linii przed końcem
set statusline=%y[%{&ff}]\ \ ASCII=\%03.3b,HEX=\%02.2B\ %=%m%r%h%w\ %1*%F%*\ %l:%v\ (%p%%)
set laststatus=2                " zawsze pokazuj linię statusu
set fo=tcrqn                    " opcje wklejania (jak maja by? tworzone wcięcia itp.)
set hidden                      " nie wymagaj zapisu gdy przechodzisz do nowego bufora
set foldtext=FoldText()         " tekst po zwinięciu zakładki
set foldminlines=5              " minimum 15 linie aby powstał fold
set wildmode=longest:full       " dopełniaj jak w BASHu
set cpoptions="A"
set tabstop=4                   " wielkość tabulacji (w spacjach)
set expandtab
set shiftwidth=4
set softtabstop=4
set incsearch
set ignorecase
set smartcase
set list
set listchars=trail:_,tab:>-
" cd na katalog, w którym znajduje się aktualny bufor
autocmd BufEnter * :lcd %:p:h
autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") |
    \ exe "normal `\"" | endif

"au BufNewFile,BufRead *.py
"    \ set expandtab       |" replace tabs with spaces
"    \ set autoindent      |" copy indent when starting a new line
"    \ set tabstop=4
"    \ set softtabstop=4
"    \ set shiftwidth=4

autocmd BufWritePre *.py execute ':Black'
nnoremap <F9> :Black<CR>

":colorscheme wombat256mod
colorscheme one
set background=dark " for the dark version
" set background=light " for the light version

if !has('gui_running')
  set t_Co=256
endif

let g:python_highlight_all = 1
