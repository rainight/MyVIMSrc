source $VIMRUNTIME/mswin.vim
behave mswin

execute pathogen#infect()

set diffexpr=MyDiff()
function! MyDiff()
	let opt = '-a --binary '
	if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
	if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
	let arg1 = v:fname_in
	if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
	let arg2 = v:fname_new
	if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
	let arg3 = v:fname_out
	if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
	let eq = ''
	if $VIMRUNTIME =~ ' '
		if &sh =~ '\<cmd'
			let cmd = '""' . $VIMRUNTIME . '\diff"'
			let eq = '"'
		else
			let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
		endif
	else
		let cmd = $VIMRUNTIME . '\diff'
	endif
	silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

fun! s:NextHelpBar()
	let s:tagHelpBar = '|[^|]*|'
	"let s:tagHelpStar = '\*[^*]*\*'
	"let link_pos = search('\('.s:tagHelpStar.'\|'.s:tagHelpBar.'\)', 'w')
	let link_pos = search('\('.s:tagHelpBar.'\)', 'w')
	if link_pos == 0
		echohl ErrorMsg | echo 'No hyperlinks' | echohl None
	else
		echo
	endif
endfun

fun! s:PreviousHelpBar()
	let s:tagHelpBar = '|[^|]*|'
	"let s:tagHelpStar = '\*[^*]*\*'
	"let link_pos = search('\('.s:tagHelpStar.'\|'.s:tagHelpBar.'\)', 'w')
	let link_pos = search('\('.s:tagHelpBar.'\)', 'bw')
	if link_pos == 0
		echohl ErrorMsg | echo 'No hyperlinks' | echohl None
	else
		echo
	endif
endfun

function! Filetype_c()
	set cindent complete=.,w,b,u,k
	set dictionary+=$VIMHOME/wordlists/c.list
	set cino+=:0 "dont' indent case:
	set cino+=g0 "indent c++ public private etc...
	if has("win32")
		compiler bcc
	endif
endfunction

function! Filetype_cpp()
	set cindent complete=.,w,b,u,k
	set dictionary+=$VIMHOME/wordlists/cpp.list
	set cino+=:0 "dont' indent case:
	set cino+=g0 "indent c++ public private etc...
	if has("win32")
		compiler bcc
	endif
endfunction

function! Filetype_perl()
	setlocal cindent
	setlocal dictionary=$VIMHOME/wordlists/perl.list
endfunction

function! Filetype_mail()
	setlocal textwidth=76
endfunction

function! Filetype_ml()
	setlocal shiftwidth=2
	setlocal softtabstop=2
	setlocal dictionary=$VIMHOME/wordlists/xml.list
endfunction

function! Filetype_tex()
	if (! filereadable('Makefile'))
		setlocal makeprg=latex\ %
	endif
	setlocal tw=80 
	setlocal autoindent
endfunction

function! Filetype_lisp()
	setlocal dictionary=$VIMHOME/wordlists/lisp.list
endfunction

function! Filetype_html()
	setlocal dictionary=$VIMHOME/wordlists/xml.list
	setlocal indentkeys-=o,O,*<Return>,<>>,<bs>
endfunction

function! Filetype_help()
	noremap <buffer> <TAB>	:call <SID>NextHelpBar()<cr>
	noremap <buffer> <S-TAB>	:call <SID>PreviousHelpBar()<cr>
endfunction

function! Term_keymap()
	set <F13>=[s
	set <F14>=<F9>
	set <F15>=[g
	set <F16>=[u
	set <F17>=[v
	set <F18>=[o
	map <F13> <C-F9>
	map <F14> <M-F9>
	map <F15> <S-F9>
	map <F16> <C-F11>
	map <F17> <C-F12>
	map <F18> <C-F5>
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible " get out of horrible vi - compatible mode
filetype on " detect the type of file
filetype plugin on " load filetype plugins
filetype indent on
set history=1000 " How many lines of history to remember
set clipboard+=unnamed " turns out I do like is sharing windows clipboard
if has("win32")
	set ffs=dos,unix,mac " support all three,in this order
else
	set ffs=unix,dos,mac " support all three,in this order
endif
set viminfo+=! " make sure it can save viminfo
set isk+=_,$,@,%,#,- " none of these should be word dividers,so make them not be
set autowrite
set autoread
set autochdir
set nobackup
set gdefault
set helplang=en,en
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set copyindent
set showbreak=\ \ \ \ \  "indicator for wrapped lines
set shellslash

"silent execute '!mkdir "'.$VIMRUNTIME.'/temp"'
"silent execute '!del "'.$VIMRUNTIME.'/temp/*~"'
set backupdir=$VIM/temp//
set directory=$VIM/temp//

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme/Colors 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on " syntax highlighting on 
if (has("gui_running"))
	set background=dark " we are using a dark background
	set nowrap
	"set guifont=Bitstream_Vera_Sans_Mono:h9:cANSI
	set guifont=Consolas:h11:cANSI
	colorscheme desert
else
	set paste "this option is useful when using Vim in a terminal
	set wrap
	colo ron
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim UI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wmh=0 "This sets the minimum window height to 0
set lsp=0 " space it out a little more (easier to read)
set wildmenu " turn on wild menu
set wildmode=list:longest,full
set ruler " Always show current positions along the bottom
"set cmdheight=2 " the command bar is 2 high
set number " turn on line numbers
set lz " do not redraw while running macros (much faster) (LazyRedraw)
set hid " you can change buffer without saving
set switchbuf=useopen 
set backspace=2 " make backspace work normal
set whichwrap=b,s,<,>,[,],h,l  " backspace and cursor keys wrap to
set mouse=a " use mouse everywhere
set shortmess=atI " shortens messages to avoid 'press a key' prompt
set report=0 " tell us when anything is changed via :...
" make the splitters between windows be blank
"set fillchars=vert:\,stl:\,stlnc:\
"hidden tool bar, menu bar and tab bar
set guioptions-=b
set guioptions-=T "get rid of toolbar
"set guioptions-=m "get rid of menu
"set guioptions-=e "remove the gui tabbar
"block combined shotkey by ALT
set winaltkeys=no
if version>=700
	set pumheight=10 "set popup menu hight
	set showtabline=2
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual Cues
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showcmd
set showmatch " show matching brackets
set matchpairs=(:),{:},[:],<:>
set mat=5 " how many tenths of a second to blink matching brackets for
set nohlsearch " do not highlight searched for phrases
set incsearch " BUT do highlight as you type you search phrase
set ignorecase smartcase
"set listchars=tab: \ | \ ,trail: .,extends: > ,precedes: < ,eol: $ " what to show when I hit :set list
"set lines=41 " 80 lines tall
"set columns=160 " 160 cols wide
set lines=45 columns=120
set so=5 " Keep 10 lines (top/bottom) for scope
set novisualbell " don't blink
set noerrorbells " no noises
set titlestring=%F
set statusline=%k(%02n)%t%m%r%h%w\ \[%{&ff}:%{&fenc}:%Y]\ \[line=%04l/%04L\ col=%03c/%03{col(\"$\")-1}]\ [%p%%]
set laststatus=2 " always show the status line
"set cursorline

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text Formatting/Layout
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set fo=tcrqn " See Help (complex)
set si " smartindent
set tabstop=4 " tab spacing (settings below are just to unify it)
set softtabstop=4 " unify
set shiftwidth=4 " unify
set noexpandtab " real tabs please!
"set nowrap
set wrap " do not wrap lines
set smarttab " use tabs at the start of a line,spaces elsewhere

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"file encoding
set fileencodings=ucs-bom,utf-8,prc,latin1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
"    Enable folding,but by default make it act like folding is off,because folding is annoying in anything but a few rare cases
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldenable " Turn on folding
"set foldmethod=indent " Make folding indent sensitive
set foldmethod=manual " Make folding indent sensitive
set foldlevel=100 " Don't autofold anything (but I can still fold manually)
set foldopen-=search " don't open folds when you search into them
set foldopen-=undo " don't open folds when you undo stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Win Manager
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:winManagerWidth=35 " How wide should it be( pixels)
let g:winManagerWindowLayout='FileExplorer' " What windows should it
"let g:winManagerWindowLayout='TagList,FileExplorer|BufExplorer' " What windows should it
let g:persistentBehaviour=0 "vim will quit if only the explorers window are the one left

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Buffer Explorer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let bufExplorerDefaultHelp=0
let bufExplorerDetailedHelp=0
let bufExplorerMaxHeight=15

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TagList
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"for Windows only
"put ctag.exe in VIM install folder
if has("win32")
	set path=.
	set path+=D:\workspace\tags,H:\\workspace\\tags
	let Tlist_Ctags_Cmd='ctags.exe' " Location of ctags
else
	set path=.
	set path+=/usr/include/**,/usr/lib/qt-3.1/include/**
	set tags=/data/home/linxd/src/linux-2.6.17.8/tags
endif
let Tlist_Sort_Type="name" " order by

let Tlist_Compact_Format=1
"Tlist_Exit_OnlyWindow need not set, if it's part of Win Manager
let Tlist_Exit_OnlyWindow=1 " if you are the last,kill yourself

" Automatically close the folds for the non-active files in the taglist window
let Tlist_File_Fold_Auto_Close=1
let Tlist_Enable_Fold_Column=0 " Do not show folding tree

"show Tlist's menu and mouse right button click menu£¬only support by taglist.vim 4.0 beta and older
let Tlist_Show_Menu=0

"Display the tags for only one file in the taglist window
let Tlist_Show_One_File=1

"Tlist_Auto_Open need not set, if it's part of Win Manager
"Display tag prototypes or tag names in the taglist window
let Tlist_Display_Tag_Scope=1
let Tlist_Close_On_Select=1
let Tlist_Display_Prototype=1
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_Highlight_Tag_On_BufEnter=1
let Tlist_Process_File_Always=0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Matchit
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let b:match_ignorecase=1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" A.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:alternateExtensions_CPP="HPP,hpp,H,h,inc"
let g:alternateExtensions_cpp="hpp,HPP,H,h,inc"
let g:alternateExtensions_C="H,h,HPP,hpp,inc"
let g:alternateExtensions_c="h,H,HPP,hpp,inc"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocommands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"start with full window
"autocmd GUIEnter * simalt ~x
"autocmd BufEnter * let &titlestring = hostname() . ':' . expand('%f')
autocmd BufEnter * : syntax sync fromstart " ensure every file does syntax highlighting (full)
"autocmd BufEnter * lcd%:p:h "automatic change working path to current folder

augroup filesetting
	autocmd FileType perl			call Filetype_perl()
	autocmd FileType c				call Filetype_c()
	autocmd FileType cpp			call Filetype_cpp()
	autocmd FileType html           call Filetype_ml()
	autocmd FileType ocaml          call Filetype_ml()
	autocmd FileType xml            call Filetype_html()
	autocmd FileType css            call Filetype_ml()
	autocmd FileType tex            call Filetype_tex()
	autocmd FileType lisp			call Filetype_lisp()
	autocmd FileType mail			call Filetype_mail()
	autocmd Filetype help			call Filetype_help()
augroup END

augroup filetypedetect
	autocmd! BufRead *.nfo set encoding=cp437
	autocmd! BufRead *.jsp set encoding=utf8
	autocmd! BufRead *.otl setfiletype vo_base
	autocmd! BufRead ~/mail/*        setlocal filetype=mail
	autocmd! BufRead /tmp/mutt*      setlocal filetype=mail
	autocmd! BufRead ~/.signature*   setlocal filetype=mail
	autocmd! BufRead ~/.mutt/*       setlocal filetype=muttrc
	autocmd! BufRead ~/.sawfish/custom setlocal filetype=lisp
	autocmd! BufRead *.*html*        setlocal filetype=html
	autocmd! BufRead *.blosxom       setlocal filetype=html
	autocmd! BufRead *.css*          setlocal filetype=css
augroup END

" When editing a file,always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\ exe "normal g`\"" |
			\ endif

if version>=700
	if has("autocmd") && exists("+omnifunc")
		autocmd Filetype *
					\ if &omnifunc=="" |
					\ setlocal omnifunc=syntaxcomplete#Complete |
					\ endif
	endif
endif

"template
"autocmd BufNewFile *.c          0read ~/.vim/skel/skel.c
"autocmd BufNewFile *.cpp        0read ~/.vim/skel/skel.cpp
"autocmd BufNewFile *.java       0read ~/.vim/skel/skel.java
"autocmd BufNewFile *.plx        0read ~/.vim/skel/skel.plx

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"key Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <Space> <PageDown>
noremap <S-Space> <PageUp>
noremap j gj
noremap k gk

" switch lines
nmap <C-Down> :<C-u>move.+1<CR>
nmap <C-Up> :<C-u>move.-2<CR>
imap <C-Down> <C-o>:<C-u>move.+1<CR>
imap <C-Up> <C-o>:<C-u>move.-2<CR>
vmap <C-Down> :move '>+1<CR>gv
vmap <C-Up> :move '<-2<CR>gv

"jone line in insert mode
inoremap <C-j> <C-o>J

"cursor move
inoremap <C-a> <Home>
inoremap <C-e> <End>
"ex mode"
cnoremap <A-B> <S-Left>
cnoremap <A-F> <S-Right>
cnoremap <C-A> <Home>
cnoremap <C-B> <Left>
cnoremap <C-D> <Del>
cnoremap <C-E> <End>
cnoremap <C-F> <Right>
cnoremap <C-N> <Down>
cnoremap <C-P> <Up>
cnoremap >fn <C-R>=expand('%:p')<CR>
cnoremap >fd <C-R>=expand('%:p:h').'/'<CR>
cnoremap >vim $VIMHOME/
cnoremap >ftp $VIMHOME/ftplugin/
cnoremap >tp  $VIMHOME/plugin/
cnoremap >rc $VIM/_vimrc
noremap <m-s-e> :e<space>**/*
noremap <m-e> :e<space>
noremap <m-g> :vimgrep<space>
noremap <m-s-n> :n<space>**/*

nnoremap  <leader>sf :vimgrep <C-R><C-W> %<CR>
nnoremap  <leader>sr :vimgrep <C-R><C-W> <C-R>=expand('%:p:h').'/**/*'<CR>

"windows compatible
nnoremap <C-S> :update<CR>
inoremap <C-S> <C-o>:update<CR>
vnoremap <C-S> <C-C>:update<CR>
nnoremap <C-Z> u
inoremap <C-Z> <C-o>u
vnoremap p <Esc>:let current_reg=@"<CR>gvdi<C-R>=current_reg<CR><Esc>
"tab opt
nnoremap <M-1> 1gt
nnoremap <M-2> 2gt
nnoremap <M-3> 3gt
nnoremap <M-4> 4gt
nnoremap <M-5> 5gt
nnoremap <M-6> 6gt
nnoremap <M-7> 7gt
nnoremap <M-8> 8gt
nnoremap <M-9> 9gt
nnoremap <M-h> :tabp<CR>
nnoremap <M-l> :tabn<CR>
nnoremap <M-t> :tabnew<CR>
nnoremap <M-w> :tabclose<CR>
nnoremap <C-Tab> gt

nnoremap <M-j> <c-w>w
inoremap <M-j> <C-o><c-w>w

nnoremap <M-k> <c-w>W
inoremap <M-k> <C-o><c-w>W

nnoremap <C-F4>:confirm bd<CR>
inoremap <C-F4> <C-o>:confirm bd<CR>

nnoremap <M-n> :bn<CR>
inoremap <M-n> <C-o>:bn<CR>

nnoremap <M-p> :bp<CR>
inoremap <M-p> <C-o>:bp<CR>

nnoremap <M-d> :Tlist<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"for winManager
"noremap <c-w><c-f> <ESC>:FirstExplorerWindow<cr>
"noremap <c-w><c-b> <ESC>:BottomExplorerWindow<cr>
"noremap <c-w><c-t> <ESC>:WMToggle<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <F1> :NERDTreeTabsToggle<CR>
nnoremap <silent> <F2> :MRU<CR>
"nnoremap <silent> <F3> :SelectBuf<CR>
"nnoremap <silent> <F2> :CalendarH<CR>
nnoremap <silent> <F3> :BufExplorer<CR>
nnoremap <silent> <F4> :%!xxd<CR>
nnoremap <silent> <S-F4> :%!xxd -r<CR>
nnoremap <silent> <F9> ms:call TitleDet()<cr>'s
function AddTitle()
	call append( 0,"///////////////////////////////////////////////////////////////////////////")
	call append( 1,"//")
	call append( 2,"//	File: ".expand("%:t"))
	call append( 3,"//  Description: ")
	call append( 4,"//")
	call append( 5,"//	Copyright (c) 2009 by Thomson Reuters. All rights reserved.")
	call append( 6,"//")
	call append( 7,"// No portion of this software in any form may be used or ")
	call append( 8,"// reproduced in any manner without written consent from ")
	call append( 9,"// Thomson Reuters")
	call append(10,"//")
	call append(11,"//    $Id$")
	call append(12,"//") 
	echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
endf
"update last modify time and file name
function UpdateTitle()
	normal m'
	execute '/# *MODIFIED:/s@:.*$@\=strftime(":  %Y-%m-%d %H:%M:%S %z")@'
	normal ''
	normal mk
	execute '/# *FILE:/s@:.*$@\=":\t\t".expand("%:t")@'
	execute "noh"
	normal 'k
	echohl WarningMsg | echo "Successful in updating the copy right." | echohl None
endfunction
"update title in first 10 lines if not find, add new
function TitleDet()
	let n=1
	"Ä¬ÈÏÎªÌí¼Ó
	while n < 20
		let line = getline(n)
		if line =~ '^\#\s*\S*MODIFIED:\S*.*$'
			call UpdateTitle()
			return
		endif
		let n = n + 1
	endwhile
	call AddTitle()
endfunction


if has("win32")
	nnoremap <S-F6> :source $VIM/_vimrc<CR>
	if version >= 700
		nnoremap <silent>  <F6> :tabe $VIM/_vimrc<CR>
	else
		nnoremap <silent>  <F6> :e $VIM/_vimrc<CR>
	endif
else
	nnoremap <S-F6> :source $HOME/.vimrc<CR>
	if version >= 700
		nnoremap <silent>  <F6> :tabe $HOME/.vimrc<CR>
	else
		nnoremap <silent>  <F6> :e $HOME/.vimrc<CR>
	endif
endif
nnoremap <silent>  <F7> :cp<CR>
nnoremap <silent>  <F8> :cn<CR>
"nnoremap <silent>  <F10> :QFix<CR>
nnoremap <silent>  <F10> :TlistToggle<CR>
nnoremap <silent>  <F11> :A<CR>
autocmd FileType c,cpp nnoremap <silent> <buffer>  <F12> mm:%!astyle --style=ansi -s4 --convert-tabs -O -S -p -L -T<CR> :update<CR>'m
autocmd FileType c,cpp inoremap <silent> <buffer>  <F12> <Esc>mm:%!astyle --style=ansi -T<CR> :update<CR>'m
nnoremap <silent>  <S-F1> :set tags=./tags,tags,h:/Gemini_Rel4.1/gemini_delivery/src/tags<CR>
nnoremap <silent>  <C-F1> :set tags=./tags,tags,h:/Mercury_Rel6.2_M610/mercury_delivery/src/tags<CR>

" Toggle spell check
" For VIM7 only
if version >= 700
	nmap <silent>  <C-F11> :set spell!<CR>
	imap <silent>  <C-F11> <C-o>:set spell!<CR>
endif

" Toggle line number
nmap <silent>  <C-F12> :set nu!<CR>
imap <silent>  <C-F12> <C-o>:set nu!<CR>
"

"For NERDCommenter
nmap <silent> <C-K> <leader>cc
imap <silent> <C-K> <leader>cc
vmap <silent> <C-K> <leader>cc
nmap <silent> <C-U> <leader>cu
imap <silent> <C-U> <leader>cu
vmap <silent> <C-U> <leader>cu

let NERDShutUp=1

"key mapping end
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"custom plugin settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"for calendar
let g:calendar_weeknm=1 " WK01
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"c support
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set author info in $VIMHOME/c-support/templates/template
"set dictionary="$VIMHOME/wordlists/c-c++-keywords.list"
"set dictionary+='$VIMHOME/wordlists/k+r.list'
"set dictionary+='$VIMHOME/wordlists/stl_index.list'
if has("win32")
	let g:C_ObjExtension=".obj"
	let g:C_ExeExtension=".exe"
	let g:C_CCompiler="gcc.exe"
	let g:C_CplusCompiler="gcc.exe"
	let g:C_CFlags="-6 -A -v -c"
	let g:C_LFlags="-6 -A -v"
	let g:C_Libs="-lm"
	let g:C_CExtension="c"
	let g:C_Comments="no"
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"hi_pern
let loaded_matchparen=0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"cppomnicpplete
"
let CppOmni_ShowScopeInAbbr = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"SuperTab£¬open cppcomplet function to use Tab auto complete word.
let g:SuperTabRetainCompletionType=2
let g:SuperTabDefaultCompletionType="<C-X><C-O>"

"Close preview window when auto complete, it can prevent flash window.
set completeopt=longest,menu 

"netrw
"let g:netrw_scp_cmd="pscp - q"
let g:netrw_liststyle = 0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"xml.vim
"let xml_use_xhtml = 1   
"let xml_no_html = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"MRU
let MRU_Max_Entries = 20
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"lookup file
"ÔÚÓÃlookupfile²å¼þ²éÕÒÎÄ¼þÊ±£¬ÊÇÇø·ÖÎÄ¼þÃûµÄ´óÐ¡Ð´µÄ£¬Èç¹ûÏë½øÐÐºöÂÔ´óÐ¡Ð´µÄÆ¥Åä£¬
"°ÑÏÂÃæÕâ¶Î´úÂë¼ÓÈëÄãµÄvimrcÖÐ£¬¾Í¿ÉÒÔÃ¿´ÎÔÚ²éÕÒÎÄ¼þÊ±¶¼ºöÂÔ´óÐ¡Ð´²éÕÒÁË£º
" lookup file with ignore case
function! LookupFile_IgnoreCaseFunc(pattern)
	let _tags = &tags
	try
		let &tags = eval(g:LookupFile_TagExpr)
		let newpattern = '\c' . a:pattern
		let tags = taglist(newpattern)
	catch
		echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
		return ""
	finally
		let &tags = _tags
	endtry    " Show the matches for what is typed so far.
	let files = map(tags, 'v:val["filename"]')
	return files
endfunction

let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'
let g:LookupFile_PreservePatternHistory = 0
let g:LookupFile_ShowFiller = 0
let g:LookupFile_PreserveLastPattern = 0
let g:LookupFile_AlwaysAcceptFirst = 1
let g:LookupFile_FileFilter = '^\.#\|\d+\.\d+$'
let g:LookupFile_TagExpr = '"H:/workspace/filenametags"'
"large file
let g:LargeFile = 10	"file size bigger than 30M will be treated as large file

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"utl.vim
let g:utl_config_highl = 'on'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"abbr
iabbr teh the
iabbr #d #define
iabbr #b /************************************************
iabbr #e ************************************************/
iabbr rt return TRUE;
iabbr rf return FALSE;
iabbr jt <c-r>=strftime("%Y-%m-%d")<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"personal settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! Fcvs :source $VIM/cvsfix.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endf 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !(has("gui_running"))
	call Term_keymap()
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"config of Perl-Support
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:Perl_AuthorName      = 'Shawn Liu'     
let g:Perl_AuthorRef       = 'Mr'                         
let g:Perl_Email           = 'Shawn.Liu@thomsonreuters.com'            
let g:Perl_Company         = 'ThomsonReuters Ltd.'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
