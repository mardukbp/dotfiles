" Runtime Path
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

" enable filetype plugin and indentation
filetype plugin indent on

"set autoindent
set tabstop=4
set softtabstop=4
set smarttab
set expandtab
set shiftwidth=4

set incsearch
set autoread

set ignorecase
syntax enable
set encoding=utf8
set wrap

colorscheme molokai
"colorscheme gruvbox
"colorscheme jellybeans
"colorscheme grb256
"colorscheme distinguished
"colorscheme vividchalk
"colorscheme breeze
set keymap=accents

set foldmethod=marker

set guifont=Consolas\ 14

" Show line numbers
" set number

" Tab completion
set wildmode=longest,list,full
set wildmenu
set wildignorecase

" Status line

function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction
set laststatus=2

set statusline+=%{SyntaxItem()}

if has('statusline')
	set statusline=%#Question#                   " set highlighting
	set statusline+=%-2.2n\                      " buffer number
	"set statusline+=%#WarningMsg#                " set highlighting
	set statusline+=%f\                          " file name
	set statusline+=%#Question#                  " set highlighting
	set statusline+=%h%m%r%w\                    " flags
	set statusline+=%{strlen(&ft)?&ft:'none'},   " file type
	set statusline+=%{(&fenc==\"\"?&enc:&fenc)}, " encoding
	set statusline+=%{((exists(\"+bomb\")\ &&\ &bomb)?\"B,\":\"\")} " BOM
	set statusline+=%{&fileformat},              " file format
	set statusline+=%{&spelllang},               " language of spelling checker
	set statusline+=%{SyntaxItem()}              " syntax highlight group under cursor
	set statusline+=%=                           " indent to the right
	set statusline+=0x%-8B\                      " character code under cursor
	set statusline+=%-7.(%l,%c%V%)\ %<%P         " cursor position/offset
endif

" Copy from above
imap <C-Up> kly$jp

" Switch between windows splitted vertically
map <leader>j :wincmd j<CR>
map <leader>k :wincmd k<CR>

" Don't wait for shift-o
" http://shallowsky.com/blog/linux/editors/vim-opening-lines.html
set ttimeoutlen=100

" Paste large amounts of text
set pastetoggle=<F2>

" Cursor movement like bash
imap <C-e> <End>
imap <C-a> <Home>
