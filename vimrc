set nocompatible
colorscheme delek
syntax enable
set encoding=utf-8

set showcmd                     
filetype off


set nu " Enable line numbers, map Ctrl-N twice to toggle them
nmap <C-N><C-N> :set invnumber<CR>

set ruler " Show the cursor position
set tabstop=3 shiftwidth=3      
set ai 
set expandtab                   
set backspace=indent,eol,start  


" Paste Mode
nnoremap <F8> :set invpaste paste?<CR>
set pastetoggle=<F8>
set showmode

set hlsearch                    
set incsearch                   
set ignorecase                  
set smartcase                   

set mouse=a " enable mouse in all modes
set ttymouse=xterm  " set mouse type to xterm

" Vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'
" Bundles
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-fugitive'
filetype plugin indent on


" quit NERDTree after opening a file
let NERDTreeQuitOnOpen=1
" colored NERD Tree
let NERDChristmasTree = 1
let NERDTreeHighlightCursorline = 1
let NERDTreeShowHidden = 1
" map enter to activating a node
let NERDTreeMapActivateNode='<CR>'
let NERDTreeIgnore=['\.git','\.DS_Store','\.pdf', '.beam']

" Toggle NERDTree with <leader>d
map <silent> <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
