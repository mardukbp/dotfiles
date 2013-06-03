" Runtime Path
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

set autoindent
set tabstop=4
set shiftwidth=4
set incsearch
set autoread
set ignorecase
syntax enable
set encoding=utf8
set wrap
colorscheme breeze
set keymap=accents

set guifont=Consolas\ 14

" Show line numbers
set number

" Tab completion
set wildmode=longest,list,full
set wildmenu
set wildignorecase

" vim-latexsuite

" Load LaTeX-Suite when a .tex file is opened
filetype plugin indent on

set grepprg=grep\ -nH\ $*

" LaTeX looks good with just a bit of indentation
set sw=2

let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_ViewRule_pdf = 'zathura'


" Spell check
autocmd BufNewFile,BufRead *.tex setlocal spell spelllang=en
"autocmd BufNewFile,BufRead *.tex setlocal spell spelllang=es

:map <F5> :setlocal spell! spelllang=en<CR>
:map <F6> :setlocal spell! spelllang=es<CR>

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
nmap <C-Up> kly$jp

" Switch between windows splitted vertically
map <leader>j :wincmd j<CR>
map <leader>k :wincmd k<CR>

" Don't wait for O
" http://shallowsky.com/blog/linux/editors/vim-opening-lines.html
set ttimeoutlen=100

" Paste large amounts of text
set pastetoggle=<F2>

" Cursor movement like bash
map <C-e> <End>
map <C-a> <Home>
