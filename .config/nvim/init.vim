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
set history=1000
set mouse=            " disable evil mouse
set termguicolors
"set number
"set relativenumber
syntax on
filetype off

" Backup
set backup
set backupdir=/tmp
set backupskip=/tmp/*
set directory=/tmp
set writebackup

"Plug Scripts-----------------------------

" Required:
call plug#begin('~/.local/share/nvim/plugged')

" Add or remove your Bundles here:
Plug 'flazz/vim-colorschemes'
Plug 'clones/vim-l9'
Plug 'ecomba/vim-ruby-refactoring'
Plug 'godlygeek/tabular'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-bundler'
Plug 'vim-scripts/AutoTag'
Plug 'rking/ag.vim'
Plug 'solars/github-vim'
Plug 'mxw/vim-jsx'
Plug 'sheerun/vim-polyglot' " syntax support for major languages
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

" Neomake and related
Plug 'neomake/neomake' " Asynchronous linting and make framework for Neovim
Plug 'jaawerth/nrun.vim' " Helps to use local binaries
Plug 'sbdchd/neoformat'

" Haskell
Plug 'bitc/vim-hdevtools'
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'

" Required:
call plug#end()

" Required:
filetype plugin indent on

"End Plug Scripts-------------------------

" Check / Format when writing a buffer (no delay).
call neomake#configure#automake('w')
let g:neomake_javascript_eslint_exe = nrun#Which('eslint')
let g:neomake_ruby_enabled_makers = ['mri', 'rubocop']

" Disable sounds in mac
set visualbell
set t_vb=

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
set wildignore+=log
set wildignore+=source_maps                      " Compiled coffeescript/etc
set wildignore+=bower_components                 " Bower components
set wildignore+=public                           " Public dir
set wildignore+=node_modules
set wildignore+=.cabal-sandbox
set wildignore+=_build,deps

set foldlevel=100
set foldmethod=indent
set foldlevelstart=99
set smartcase         " case sensitive
set pastetoggle=<F11>
set winminheight=0    " minimal window height
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

" ; key repeats last search. bind it to \ and ;; so we can use ; as a leader key
nnoremap ;; ;
nnoremap \ ;
map ;; <Plug>SneakNext
map \ <Plug>SneakNext
let g:sneak#s_next = 1

let mapleader = ";"
let &winwidth = 100

let ruby_operators = 1 " hightlight ruby operators
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1

" Use ag instead of grep
"   brew install the_silver_searcher
let g:agprg = 'ag --vimgrep'
let g:ag_highlight=1
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_use_caching = 0
set grepprg=ag\ --vimgrep
nnoremap <leader>a :Ag<space>

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

autocmd BufEnter *.html set filetype=xhtml
autocmd BufEnter */nginx/*.conf* set filetype=nginx
autocmd BufEnter *.html.erb source $HOME/.vim/syntax/html5.vim
autocmd BufEnter *.es6 set filetype=javascript
autocmd BufEnter Procfile set filetype=ruby
autocmd BufEnter *.prawn set filetype=ruby
autocmd BufEnter Guardfile set filetype=ruby
autocmd BufEnter Gemfile set filetype=ruby
autocmd BufEnter *.slim set filetype=slim

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" CtrlP
let g:ctrlp_map = "<leader>t"
let g:ctrlp_root_markers = ['start', 'package.json']

" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
map <leader>e :e <C-R>=expand("%:p:h") . '/'<CR><C-M>
map <leader>s :split <C-R>=expand("%:p:h") . '/'<CR><C-M>
map <leader>v :vnew <C-R>=expand("%:p:h") . '/'<CR><C-M>

" Copy/paste from system clipboard
map <leader>y "+y
map <leader>p "+p

" splitjoin
nmap <leader>J :SplitjoinJoin<cr>
nmap <leader>S :SplitjoinSplit<cr>

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

" => to :, " to ' and add spaces
function! PrettyHash()
  :Bashrockets
  :silent! s/\"\([a-zA-Z_]*\)\"\:/\1\:\ /g
  :silent! s/\(\w\|\}\|\'\|\"\)\:\(\w\|{\|\'\|\"\)/\1\: \2/g
  :silent! s/\"/\'/g
  :silent! s/\(\w\|\}\|\'\|\"\),\(\w\)/\1, \2/g
endfunction
vnoremap <silent> <leader>h :call PrettyHash()<cr>

function! SplitHash()
  :silent! s/^\(\s\+\){\(.*\)/\1{\r\1\ \ \2/g
  :silent! s/\(\w\|\}\|\'\|\"\|)\), \(\w\)/\1,\r\2/g
  :silent! s/\}$/\r\}/g
endfunction
vnoremap <silent> <leader>j :call SplitHash()<cr>

" Move line(s) of text using Alt+j/k
nnoremap <silent> <A-j> :m+<CR>==
nnoremap <silent> <A-k> :m-2<CR>==
inoremap <silent> <A-j> <Esc>:m+<CR>==gi
inoremap <silent> <A-k> <Esc>:m-2<CR>==gi
vnoremap <silent> <A-j> :m'>+<CR>gv=gv
vnoremap <silent> <A-k> :m-2<CR>gv=gv

" move between several split windows
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" move between tabs (alt-h, alt-l)
nmap è :tabp<CR>
nmap ì :tabn<CR>
nmap <M-h> :tabp<CR>
nmap <M-l> :tabn<CR>
tnoremap è <C-\><C-n>:tabp<CR>
tnoremap ì <C-\><C-n>:tabn<CR>
tnoremap <M-h> <C-\><C-n>:tabp<CR>
tnoremap <M-l> <C-\><C-n>:tabn<CR>

" terminal shortcuts
tnoremap <Esc> <C-\><C-n>
tnoremap <C-w>_ <C-\><C-n><C-w>_
tnoremap <C-u> <C-\><C-n><C-u>
tnoremap <C-d> <C-\><C-n><C-d>

" grep for the word under the cursor
nnoremap <Leader>w :split <CR> :grep <cword> . <CR>

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
  :tabnew
  :call termopen([&sh, &shcf, "bundle exec rspec " . a:filename], {'name':'running-tests'})
  :startinsert
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

map <leader>c :call RunTestFile()<cr>
map <leader>x :bd! running-tests<cr>

" Haskell
map <silent> tw :GhcModTypeInsert<CR>
map <silent> ts :GhcModSplitFunCase<CR>
map <silent> tq :GhcModType<CR>
map <silent> te :GhcModTypeClear<CR>

" Highlight 121st column if text flows over it
call matchadd('ColorColumn', '\%>120v.\+', 100)

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" disabled because 'my' expects gui* commands, but neovim disabled gui_running
" so it expects cterm* commands. Sad :(
"colorscheme my
set background=dark
colorscheme vividchalk
