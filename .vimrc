set nocompatible      " use vim defaults
set history=50        " number of lines that are remembered
set nobk              " no backup when overwriting
set ttyfast           " fast terminal
set smarttab          " smart tab
set title             " nice terminal title
set splitbelow        " new spilt window below where you are
set splitright        " new vsplit windows right where you are
set shiftround        " < and > commands for indention
set expandtab         " use spaces instead of <Tab>s
set tabstop=2         " number of spaces that a <Tab> in the file counts for
set shiftwidth=2      " number of spaces to use for each step of (auto)indent
set softtabstop=2     " spaces feel like tabs
set smartindent       " auto tabs when going to next line
set modeline
set incsearch
set autoindent        " always set auto-indenting on
set copyindent        " copy the previous indentation on auto-indenting
set ruler             " line and column number
set backspace=indent,eol,start
set encoding=utf-8
set confirm           " asks confirmation when read-only etc
set scrolloff=3       " keep 3 lines when scrolling
set sidescrolloff=2   " keep 2 characters when scrolling
set showmatch         " jumps to next bracket
set nospell
set spelllang=en
set history=1000

" This makes RVM work inside Vim. I have no idea why.
set shell=bash

" Disable sounds in mac
set visualbell
set t_vb=

" Use ack instead of grep
set grepprg=ack-grep\ --ignore-dir=log\ --ignore-dir=tmp

set wildmode=list:longest
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code
set wildignore+=classes
set wildignore+=lib
set wildignore+=log

set foldlevel=100
set foldmethod=indent
set foldlevelstart=99
set smartcase         " case sensitive
set pastetoggle=<F11>
set foldcolumn=0      " column for fold marks
set wmh=0             " minimal window height
set hidden            " less warning when dealing with buffers

set laststatus=2                " always show status line
set statusline=                 " build the status line
set statusline+=%-3.3n\         " buffer number
set statusline+=%f\             " filename
set statusline+=%h%m%r%w        " status flags
set statusline+=%y              " file type
set statusline+=%=              " right align remainder
set statusline+=0x%-8B          " character value
set statusline+=%-14(%l,%c%V%)  " line, character
set statusline+=%<%P            " file position

" Move line(s) of text using Alt+j/k
"set termencoding=latin1
nnoremap <silent> <A-j> :m+<CR>==
nnoremap <silent> <A-k> :m-2<CR>==
inoremap <silent> <A-j> <Esc>:m+<CR>==gi
inoremap <silent> <A-k> <Esc>:m-2<CR>==gi
vnoremap <silent> <A-j> :m'>+<CR>gv=gv
vnoremap <silent> <A-k> :m-2<CR>gv=gv

let mapleader = ";"
let ruby_operators = 1 " hightlight ruby operators

" required by Vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'slim-template/vim-slim'
Bundle 'clones/vim-l9'
Bundle 'depuracao/vim-rdoc'
Bundle 'ecomba/vim-ruby-refactoring'
Bundle 'godlygeek/tabular'
Bundle 'jgdavey/vim-blockle'
Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/ctrlp.vim'
Bundle 'postmodern/vim-yard'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-rake'
Bundle 'tpope/vim-surround'
Bundle 'Valloric/YouCompleteMe'
Bundle 'vim-ruby/vim-ruby'
Bundle 'vim-scripts/AutoTag'
Bundle 'mhinz/vim-startify'

filetype plugin indent on
syntax on

" Show trailing whitespace, but don't highlight the extra whitespace while
" typing, only after leaving insert
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" Don't make a # force column zero.
inoremap # X<BS>#

" FILE TYPES / SYNTAX
source $VIMRUNTIME/filetype.vim
source $VIMRUNTIME/macros/matchit.vim

autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

autocmd BufEnter *.html set filetype=xhtml
autocmd BufEnter */nginx/*.conf* set filetype=nginx
autocmd BufEnter *.html.erb source $HOME/.vim/syntax/html5.vim

autocmd BufEnter *.prawn set filetype=ruby
autocmd BufEnter Guardfile set filetype=ruby
autocmd BufEnter Gemfile set filetype=ruby

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" FuzzyFinderTextMate
let g:ctrlp_map = "<leader>t"

" Regenerate tags
map <leader>rt :!ctags --extra=+f --languages=-javascript --exclude=.git --exclude=log -R * `rvm gemdir`/gems/*
"map <leader>rt :!ctags --extra=+f --languages=-javascript --exclude=.git --exclude=log -R * `rvm gemdir`/gems/*<CR><C-M>

" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
map <leader>e :e <C-R>=expand("%:p:h") . '/'<CR><C-M>
map <leader>s :split <C-R>=expand("%:p:h") . '/'<CR><C-M>
map <leader>v :vnew <C-R>=expand("%:p:h") . '/'<CR><C-M>

map <leader>n :tabn<cr>
map <leader>m :tabp<cr>

" Copy/paste from system clipboard
map <leader>y "+y
map <leader>p "+p

" move over screen lines not buffer lines
"  helps with long wrapped lines (normal mode only)
noremap k gk
noremap j gj

" Fix cursor position when using page up and down
map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>
set nostartofline

nmap <silent> <leader>z :set spell!<cr>

" Move line(s) of text using Alt+j/k
" Figure out why this is not working?
nnoremap <silent> <A-j> :m+<CR>==
nnoremap <silent> <A-k> :m-2<CR>==
inoremap <silent> <A-j> <Esc>:m+<CR>==gi
inoremap <silent> <A-k> <Esc>:m-2<CR>==gi
vnoremap <silent> <A-j> :m'>+<CR>gv=gv
vnoremap <silent> <A-k> :m-2<CR>gv=gv

" move between several split windows maximizing the active one
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l

" In insert mode, hold down control to do movement, cursor keys suck.
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>

" set/unset folds with ctrl-space
nmap <Nul> za

" strip trailing whitespace with F5
function! <SID>StripTrailingWhitespaces()
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
nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Running tests
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Write the file and run tests for the given filename
function! RunTests(filename)
  :w
  :silent !echo;echo;echo;echo;echo
  if match(a:filename, '\.feature$') != -1
    exec ":!bundle exec cucumber " . a:filename
  else
    exec ":!rspec --drb " . a:filename
  end
endfunction

" Set the spec file that tests will be run for.
function! SetTestFile()
  let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " Run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_line_number)
endfunction

map <leader>c :call RunTestFile()<cr>
map <leader>C :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>

" nice colorscheme
set t_Co=256 " number of colors
set background=dark
colorscheme vividchalk
