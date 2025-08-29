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

" Misc plugins
Plug 'flazz/vim-colorschemes' " colorschemes
Plug 'tpope/vim-fugitive' " git wrapper
Plug 'tpope/vim-surround'
Plug 'sheerun/vim-polyglot' " syntax support for major languages

" Github integration (Basically only using `vmap gho`)
Plug 'solars/github-vim'

" Autocomplete and search
Plug 'ctrlpvim/ctrlp.vim'
Plug 'rking/ag.vim'

" Erlang
Plug 'vim-erlang/vim-erlang-runtime'

" Javascript
Plug 'neoclide/vim-jsx-improve'

" Ruby
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'

" GoLang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Neomake and related
Plug 'neomake/neomake' " Asynchronous linting and make framework for Neovim
Plug 'jaawerth/nrun.vim' " Helps to use local binaries
Plug 'sbdchd/neoformat'

" Test shortcuts for rspec and others
Plug 'vim-test/vim-test'

" Solidity
Plug 'thesis/vim-solidity'

" Community managed lsp configs
Plug 'neovim/nvim-lspconfig'

" Autocomplete
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Required:
call plug#end()

" Required:
filetype plugin indent on

"End Plug Scripts-------------------------

" Check / Format when writing a buffer (no delay).
call neomake#configure#automake('w')
let g:neomake_javascript_enabled_makers = [] " We use Coc
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

" Map Ctrl+P, Ctrl+N to prev-next search result
nnoremap <silent> <C-p> :cp<CR>
nnoremap <silent> <C-n> :cn<CR>

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

" File types / syntax
source $VIMRUNTIME/filetype.lua
autocmd BufEnter */nginx/*.conf* set filetype=nginx
autocmd BufEnter */kubernetes/*.template set filetype=yaml
autocmd BufEnter *.yaml.gotmpl set filetype=yaml

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" CtrlP
let g:ctrlp_map = "<leader>t"
let g:ctrlp_root_markers = ['start', 'package.json', 'Gemfile']

" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
map <leader>e :e <C-R>=expand("%:p:h") . '/'<CR><C-M>
map <leader>s :split <C-R>=expand("%:p:h") . '/'<CR><C-M>
map <leader>v :vnew <C-R>=expand("%:p:h") . '/'<CR><C-M>

" Copy/paste from system clipboard
map <leader>y "+y
map <leader>p "+p

map Y 0y$$

" move over screen lines not buffer lines
"  helps with long wrapped lines (normal mode only)
noremap k gk
noremap j gj

" move between several split windows
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

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

" vim-test configuration
let test#strategy = "neovim" " Runs test commands with :terminal in a split window
let test#neovim#term_position = "tab" " Create new tab instead of split window
nnoremap <silent> <Leader>c :TestNearest<CR>
nnoremap <silent> <Leader>C :TestSuite<CR>

" Highlight 121st column if text flows over it
call matchadd('ColorColumn', '\%>120v.\+', 100)

" don't give |ins-completion-menu| messages.
set shortmess+=c

colorscheme vividchalk
highlight Normal guibg=Black ctermbg=Black
highlight SignColumn guibg=#222222
