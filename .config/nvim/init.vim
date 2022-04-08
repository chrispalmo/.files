set nocompatible

"disable this fkn autocomplete thing
let g:omni_sql_no_default_maps = 1

"Vundle
filetype off
set rtp+=/usr/local/opt/fzf
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-commentary'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-surround'
Plugin 'AndrewRadev/splitjoin.vim'
Plugin 'junegunn/fzf.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'yuezk/vim-js'
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'HerringtonDarkholme/yats.vim'
call vundle#end()
filetype plugin indent on

"airline
let g:airline#extensions#tabline#enabled = 1 "enable the list of buffers
let g:airline#extensions#tabline#formatter = 'unique_tail_improved' "name buffers unambiguously

"fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs --hidden -g "!node_modules/" -g "!.git/*" -g "!*.pyc" -g "!frontend/coverage/*" -g "!venv" -g "!env"'

"NERDTree
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeNaturalSort = 1
let NERDTreeCaseSensitiveSort = 1
let g:NERDTreeWinSize=50
nmap <C-]> :NERDTreeToggle<cr>
nmap <leader>r :NERDTreeFind<cr>

"general
syntax on
#set clipboard+=unnamedplus "Yank to the system clipboard (*** warning ***: can break large macros)
set cursorline
set encoding=utf-8 nobomb
set ignorecase smartcase "when searching with / ignore case unless uppercase is used
set nobackup
set nowrap
set nospell
set number
set ruler
set showtabline=2 "always show tab bar
set wildignore=*.class,.zsh_history,.zcompdump,*/node_modules/**/*,*.aux,*/.git/**/*,*/venv/**/*,*/env/**/*
set incsearch
set hlsearch
set relativenumber
set nojoinspaces "one space instead of two when doing gq
set textwidth=80
set suffixesadd=.js

"swap
set directory=~/.vim/swaps

"macvim
set guifont=Menlo:h15

"colors
colorscheme desert

"tabs
set expandtab "<tab> produces spaces
set softtabstop=4 "num spaces with <tab>
set shiftwidth=4 "num spaces with < and >
set tabstop=8 "num spaces rendered by a tab character

"indentation
set autoindent
set smartindent

"buffers and tabs
set hidden
nmap <tab> :bnext<cr>
nmap <s-tab> :bprevious<cr>
nmap <leader>q :bp <bar> bd #<cr>
nmap <leader>b :bufdo bd<cr>
nmap <leader>h :hide<cr>
nmap <c-t> :Files<cr>
nmap <c-s> :Buffers<cr>

"search current selection
vnoremap <leader>f "zy/<c-r>z<cr>

"center search result
nnoremap n nzz
nnoremap N Nzz

"clear search
nmap <c-n> :noh<cr>

"nopaste
nmap <c-o> :set nopaste<cr>

"disable ex mode
nmap Q <nop>

"handy shortcuts
nnoremap ! g*
vnoremap ! y:Rg <c-r>"<cr>
vnoremap / <esc>/<c-r>"<cr>

"horizontal navigation
nnoremap <m-h> 4zh
nnoremap <m-l> 4zl

"window navigation
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

"paragraph navigation
noremap <c-k> {
noremap <c-j> }

"remap <esc>
inoremap <c-c> <esc>

"emacsy bash bindings
inoremap <c-a> <c-o>^
inoremap <c-d> <c-o>x
inoremap <c-e> <c-o>$
inoremap <c-k> <c-o>C
inoremap <c-l> <c-o>dw
inoremap <c-u> <c-o>S

"discard junk from default register when we use s/S
nnoremap s "_s
nnoremap S "_S
vnoremap s "_s

"keep default register when we use p/P
vnoremap p pgvy
vnoremap P Pgvy

"scroll up easier
nnoremap K <c-y>

"easier alias for $ (conveniently next to 0)
nnoremap - $
vnoremap - $h

"wq accidental capitals
command Wq wq
command WQ wq
command W w
command Q q
command Sort sort
command S sort

"open vimrc
command VR e ~/.vimrc
command VT e ~/.tmux.conf
command VZ e ~/.zshrc

"make brackets useful
nnoremap ( F(
nnoremap ) f)
vnoremap ( F(
vnoremap ) f)

"emacs-inspired zz
nnoremap <m-l> zz

"common things to type
inoremap <leader>p import pdb; pdb.set_trace()<esc>
inoremap <leader>c console.log(
inoremap <leader>d debugger;<esc>

"clear whitespace on save
autocmd BufWritePre * %s/\s\+$//e

autocmd FileType typescriptreact setlocal suffixesadd+=.ts

" Enable undo file so you can undo after saving
if has('persistent_undo')
  silent !mkdir -p $HOME/.vim/undo
  set undofile
  set undodir=$HOME/.vim/undo
endif
