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
set foldminlines=15             " minimum 15 linie aby powstał fold
set wildmode=longest:full      	" dopełniaj jak w BASHu
set cpoptions="A"
set keymodel=startsel,stopsel  	" zaznaczanie z shiftem
let python_highlight_all = 1
let Tlist_Use_Right_Window = 1 	" panel tag?w po prawej
set ts=4           		        " wielkość tabulacji (w spacjach)
set expandtab
set shiftwidth=4
set softtabstop=4
behave xterm
if &t_Co > 2 || has("gui_running")
		syntax on              " kolorowanie składni
		set hlsearch           " zaznaczanie szukanego tekstu
		colorscheme wombat     " domyślny schemat kolorów
endif
if has("gui_running")
		set foldcolumn=2       		" szerokość kolumny z zakładkami
		set guioptions=abegimrLtT 	" m.in: włącz poziomy scrollbar
		set nowrap
		set cursorline         	    " zaznacz linię z kursorem
		set gfn=Courier\ New\ 8
        highlight SpellBad term=underline gui=undercurl guisp=Orange
endif
" automatyczne rozpoznawanie typu pliku, ładowanie specyficznego, dla danego typu, pluginu (ftplugin.vim, indent.vim):
filetype plugin indent on
" cd na katalog, w którym znajduje się aktualny bufor
autocmd BufEnter * :lcd %:p:h
" zaczynaj od ostatniej znanej pozycji kursora:
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g`\"" | endif
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

""" KLAWISZOLOGIA: """
" session manager
"nmap <F12>  :call SessionManagerToggle()<CR>
"inoremap        <Tab>   <C-R>=InsertTabWrapper("backward")<CR>
"inoremap        <S-Tab> <C-R>=InsertTabWrapper("forward")<CR>
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
" sprawdzanie pisowni
map     <silent><F7>     :setlocal spell!<CR>
imap    <silent><F7>     <ESC>:setlocal spell!<CR>i<right>
" przemieszczanie zakładek (tabów) kombinacją ALT+, ALT+.
map <silent> <M-.> :if tabpagenr() == tabpagenr("$")\|tabm 0\|el\|exe "tabm ".tabpagenr()\|en<CR>
map <silent> <M-,> :if tabpagenr() == 1\|exe "tabm ".tabpagenr("$")\|el\|exe "tabm ".(tabpagenr()-2)\|en<CR>
" Uzupełnianie wyrazów przez <Tab> - TIP #102:
function! InsertTabWrapper(direction)
        let col = col('.') - 1
        if !col || getline('.')[col - 1] !~ '\k'
                return "\<tab>"
        elseif "backward" == a:direction
                return "\<c-p>"
        else
                return "\<c-n>"
        endif
endfunction
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

" Automatyczne dopełnianie nawiasów
imap  ( (<Esc>:call Nawias()<CR>a
imap  [ [<Esc>:call Nawias()<CR>a
imap  { {<Esc>:call Nawias()<CR>a

function! Nawias()
  execute "normal %"
  let zmienna = getline(".")[col(".") - 1]
  if zmienna == '['
    execute "normal a]"
  endif
  if zmienna == '('
    execute "normal a)"
  endif
  if zmienna == '{'
    execute "normal a}"
  endif
  execute "normal %"
endfunction
" TaskList
map     <silent><F2>     :TaskList<CR>
" Tlist
map     <silent><F3>     :Tlist<CR>

autocmd FileType python compiler pylint

" vim: fdm=marker
