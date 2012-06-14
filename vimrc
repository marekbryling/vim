set spelllang=pl,en
set encoding=utf-8
set fileencodings=utf-8 	    " domyślne kodowanie
set nocompatible                " niekompatybilny z VI => w??cz bajery VIMa
set nobackup                    " nie trzymaj kopii zapasowych, używaj wersji
set backspace=indent,eol,start
set viminfo='20,\"50            " read/write a .viminfo file, don't store more than 50 lines of registers
set history=50                  " keep 50 lines of command line history
set ruler                       " show the cursor position all the time
set showcmd                     " display incomplete commands
set incsearch                   " do incremental searching
set browsedir=buffer            " To get the File / Open dialog box to default to the current file's directory
set autoindent 			        " automatyczne wcięcia
set pastetoggle=<F11>           " przełączanie w tryb wklejania (nie będzie automatycznych wcięć, ...)
set number                 	    " pierwszy odpalony bufor ma numerki
set wildmenu                    " wyświetlaj linie z menu podczas dope?niania
set showmatch                   " pokaz otwieraj?cy nawias gdy wpisze zamykaj?cy
set so=5                        " przewijaj już na 5 linii przed końcem
set statusline=%y[%{&ff}]\ \ ASCII=\%03.3b,HEX=\%02.2B\ %=%m%r%h%w\ %1*%F%*\ %l:%v\ (%p%%)
set laststatus=2                " zawsze pokazuj linię statusu
set fo=tcrqn                    " opcje wklejania (jak maja by? tworzone wcięcia itp.)
set hidden                      " nie wymagaj zapisu gdy przechodzisz do nowego bufora
set tags+=./stl_tags            " tip 931
set foldtext=FoldText()         " tekst po zwinięciu zakładki
set foldminlines=5             " minimum 15 linie aby powstał fold
set wildmode=longest:full      	" dopełniaj jak w BASHu
set cpoptions="A"
set keymodel=startsel,stopsel  	" zaznaczanie z shiftem
"let python_highlight_all = 1
let Tlist_Use_Right_Window = 1 	" panel tag?w po prawej
set tabstop=8           		        " wielkość tabulacji (w spacjach)
set expandtab
set shiftwidth=4
set softtabstop=4
let g:miniBufExplorerMoreThanOne=1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplMapCTabSwitchWindows = 1
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplModSelTarget = 1
behave xterm
if &t_Co > 2 || has("gui_running")
		syntax on              " kolorowanie składni
		set hlsearch           " zaznaczanie szukanego tekstu
endif
if has("gui_running")
		set foldcolumn=2       		" szerokość kolumny z zakładkami
		set guioptions=abegimrLtT 	" m.in: włącz poziomy scrollbar
		set nowrap
		set cursorline         	    " zaznacz linię z kursorem
		set gfn=Courier\ New\ 8
        highlight SpellBad term=underline gui=undercurl guisp=Orange
		colorscheme wombat     " domyślny schemat kolorów
endif

python << EOF
import os
import sys
import vim
sys.path.append("/home/marek/.local/lib/python2.6/site-packages")
EOF

" automatyczne rozpoznawanie typu pliku, ładowanie specyficznego, dla danego typu, pluginu (ftplugin.vim, indent.vim):
filetype plugin indent on

" folding 
augroup vimrc
  au BufReadPre * setlocal foldmethod=indent
  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END


" cd na katalog, w którym znajduje się aktualny bufor
autocmd BufEnter * :lcd %:p:h
" usuń białe znaki z końców linii przy zapisie
autocmd BufWritePre *.py normal m`:%s/\s\+$//e``
" zaczynaj od ostatniej znanej pozycji kursora:
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g`\"" | endif
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

""" KLAWISZOLOGIA: """
" szukaj zaznaczonego tekstu z '*' i '#' (a nie tylko wyrazu pod kursorem):
vnoremap        *        y/<C-R>"<CR>
vnoremap        #        y?<C-R>"<CR>
" wyszukiwanie TYLKO w zaznaczonym fragmencie:
vnoremap        /        <ESC>/\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
vnoremap        ?        <ESC>?\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
map        <silent><C-W>N              <ESC>:tabnew<CR>
imap       <silent><C-W>N              <ESC>:tabnew<CR>
nmap       <silent><F9>                <ESC>:NERDTree<CR>
imap       <silent><F9>                <ESC>:NERDTree<CR>
map 	   <silent>.            	<ESC>:tabnext<CR>
map        <silent>,			<ESC>:tabprevious<CR>
"map            <silent><C-W><backspace><backspace>     <ESC>:e #<CR>
"imap           <silent><C-W><backspace><backspace>     <ESC>:e #<CR>
" vcs
map 	   <silent><F4>            	<ESC>:VCSVimDiff<CR>
map 	   <silent><M-F4>            	<ESC>:VCSVimDiff HEAD^<CR>
" sprawdzanie pisowni
map     <silent><F7>     <ESC>:setlocal spell!<CR>
imap    <silent><F7>     <ESC>:setlocal spell!<CR>i<right>
" przemieszczanie zakładek (tabów) kombinacją ALT+, ALT+.
map <silent> <M-.> :if tabpagenr() == tabpagenr("$")\|tabm 0\|el\|exe "tabm ".tabpagenr()\|en<CR>
map <silent> <M-,> :if tabpagenr() == 1\|exe "tabm ".tabpagenr("$")\|el\|exe "tabm ".(tabpagenr()-2)\|en<CR>
function! s:DiffWithSaved()
        let filetype=&ft
        diffthis
        " new | r # | normal 1Gdd - for horizontal split
        vnew | r # | normal 1Gdd
        diffthis
        execute "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
command! Diff call s:DiffWithSaved()
let html_use_css=1     " domyślne używa CSS zamiast <font>

" TaskList
map     <silent><F2>     :TaskList<CR>

" Remove trailing whitespace
function <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

"remove all trailing whitespace for specified files before write
autocmd BufWritePre *.py :call <SID>StripTrailingWhitespaces()
autocmd BufWritePre *.rst :call <SID>StripTrailingWhitespaces()
autocmd BufWritePre *.wiki :call <SID>StripTrailingWhitespaces()
autocmd BufWritePre *.js :call <SID>StripTrailingWhitespaces()
autocmd BufWritePre *.css :call <SID>StripTrailingWhitespaces()
autocmd BufWritePre *.xml :call <SID>StripTrailingWhitespaces()


"autocmd FileType python compiler pylint

" vim: fdm=marker
