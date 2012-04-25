set nocompatible
colorscheme delek
syntax enable
set encoding=utf-8

set showcmd                     
filetype plugin indent on       

set nu " Enable line numbers
set ruler " Show the cursor position
set tabstop=3 shiftwidth=3      
set ai 
set expandtab                   
set backspace=indent,eol,start  

nnoremap <F8> :set invpaste paste?<CR>
set pastetoggle=<F8>
set showmode

set hlsearch                    
set incsearch                   
set ignorecase                  
set smartcase                   

set mouse=a " enable mouse in all modes
set ttymouse=xterm  " set mouse type to xterm
