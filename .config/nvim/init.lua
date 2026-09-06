vim.g.mapleader = ';'

-- Plugins (vim-plug)
vim.cmd([[
call plug#begin('~/.local/share/nvim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-test/vim-test'

Plug 'nvim-treesitter/nvim-treesitter', { 'branch': 'main', 'do': ':TSUpdate' }

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

call plug#end()
]])

-- Options
local o = vim.o
o.title = true
o.splitbelow = true
o.splitright = true
o.shiftround = true
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.confirm = true
o.scrolloff = 3
o.sidescrolloff = 2
o.showmatch = true
o.mouse = ''
o.termguicolors = true
o.updatetime = 300
o.wildmode = 'list:longest'
o.foldmethod = 'indent'
o.foldlevel = 100
o.foldlevelstart = 99
o.winminheight = 0
o.winwidth = 100
o.shortmess = o.shortmess .. 'c'
o.grepprg = 'ag --vimgrep'
o.statusline = '%-3.3n %f %h%m%r%w%y%=0x%-8B%-14(%l,%c%V%)%<%P'

vim.opt.wildignore:append({
  '.hg', '.git', '.svn',
  '*.aux', '*.out', '*.toc',
  '*.jpg', '*.bmp', '*.gif', '*.png', '*.jpeg',
  '*.o', '*.obj', '*.exe', '*.dll', '*.manifest',
  '*.spl', '*.sw?', '*.DS_Store', '*.luac', '*.pyc',
  'migrations', 'classes', 'log', 'source_maps',
  'bower_components', 'public', 'node_modules',
  '.cabal-sandbox', '_build', 'deps',
})

-- Filetypes
vim.filetype.add({
  pattern = {
    ['.*/kubernetes/.*%.template'] = 'yaml',
    ['.*%.yaml%.gotmpl'] = 'yaml',
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'text',
  callback = function() vim.bo.textwidth = 78 end,
})

-- Trailing whitespace: highlight it, but not the line being typed on
vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = 'red', ctermbg = 'red' })
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function() vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = 'red', ctermbg = 'red' }) end,
})
vim.cmd([[match ExtraWhitespace /\s\+$/]])
vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function() vim.cmd([[match ExtraWhitespace /\s\+\%#\@<!$/]]) end,
})
vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function() vim.cmd([[match ExtraWhitespace /\s\+$/]]) end,
})

local function strip_trailing_whitespace()
  local view = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.fn.winrestview(view)
end

-- Mappings
local map = vim.keymap.set

-- Quickfix navigation
map('n', '<C-p>', ':cp<CR>', { silent = true })
map('n', '<C-n>', ':cn<CR>', { silent = true })

-- ; is the leader, so repeat f/t with ;; or \
map('n', ';;', ';')
map('n', '\\', ';')

-- Search with ag
map('n', '<leader>a', ':grep<space>')
map('n', '<leader>w', ':split<CR>:grep <cword> .<CR>')

-- Edit a file in the directory of the current file
map('', '<leader>e', ":e <C-R>=expand('%:p:h') . '/'<CR><CR>")
map('', '<leader>s', ":split <C-R>=expand('%:p:h') . '/'<CR><CR>")
map('', '<leader>v', ":vnew <C-R>=expand('%:p:h') . '/'<CR><CR>")

-- System clipboard
map('', '<leader>y', '"+y')
map('', '<leader>p', '"+p')

-- Move over screen lines, not buffer lines
map('', 'k', 'gk')
map('', 'j', 'gj')

-- Move between windows, also from a terminal
for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
  map('n', '<C-' .. key .. '>', '<C-w>' .. key)
  map('t', '<C-' .. key .. '>', '<C-\\><C-n><C-w>' .. key)
end

-- Terminal
map('t', '<Esc>', '<C-\\><C-n>')
map('t', '<C-w>_', '<C-\\><C-n><C-w>_')
map('t', '<C-u>', '<C-\\><C-n><C-u>')
map('t', '<C-d>', '<C-\\><C-n><C-d>')

map('n', '<F5>', strip_trailing_whitespace, { silent = true })

-- CtrlP
vim.g.ctrlp_map = '<leader>t'
vim.g.ctrlp_root_markers = { 'start', 'package.json', 'Gemfile' }
vim.g.ctrlp_user_command = 'ag %s -l --nocolor -g ""'
vim.g.ctrlp_use_caching = 0

-- vim-test: run tests in a :terminal in a new tab
vim.g['test#strategy'] = 'neovim'
vim.g['test#neovim#term_position'] = 'tab'
map('n', '<leader>c', ':TestNearest<CR>', { silent = true })
map('n', '<leader>C', ':TestSuite<CR>', { silent = true })

-- Colors
vim.cmd.colorscheme('vividchalk')
vim.cmd.highlight('Normal guibg=Black ctermbg=Black')
vim.cmd.highlight('SignColumn guibg=#222222')

-- Treesitter: nvim-treesitter only installs parsers, Neovim does the highlighting
require('nvim-treesitter').install({
  'bash', 'css', 'diff', 'dockerfile', 'eex', 'elixir', 'erlang', 'gitcommit',
  'go', 'heex', 'html', 'javascript', 'json', 'lua', 'markdown',
  'markdown_inline', 'ruby', 'tsx', 'typescript', 'vim', 'vimdoc', 'yaml',
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if lang and vim.treesitter.language.add(lang) then
      vim.treesitter.start(args.buf)
    end
  end,
})

-- Completion
local cmp = require('cmp')

cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
  }),
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})

-- Diagnostics
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, { scope = 'cursor', focusable = false })
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  float = {
    border = 'rounded',
    winhighlight = 'Normal:DiagnosticFloat',
  },
})

-- LSP: configs come from nvim-lspconfig
vim.lsp.enable({ 'expert', 'gopls', 'ts_ls' })
