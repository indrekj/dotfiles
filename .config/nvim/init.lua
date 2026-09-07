vim.g.mapleader = ';'

-- Plugins (vim.pack, built into Neovim). Update with :lua vim.pack.update()

-- Parsers are built against the nvim-treesitter revision, so rebuild them
-- whenever the plugin itself changes. Fresh installs are handled by the
-- install() call further down.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
      vim.cmd.TSUpdate()
    end
  end,
})

vim.pack.add({
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-rhubarb',
  'https://github.com/tpope/vim-surround',
  'https://github.com/tpope/vim-rails',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/vim-test/vim-test',

  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },

  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/hrsh7th/cmp-path',
  'https://github.com/hrsh7th/cmp-cmdline',
})

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
o.grepprg = 'rg --vimgrep --smart-case'
o.grepformat = '%f:%l:%c:%m'
o.undofile = true
o.ignorecase = true
o.smartcase = true
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

-- Trailing whitespace: highlight it, but not the line being typed on.
-- :match is window-local, so it has to be set again for every new window.
local function match_trailing_whitespace()
  vim.cmd([[match ExtraWhitespace /\s\+$/]])
end
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'InsertLeave' }, { callback = match_trailing_whitespace })
vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function() vim.cmd([[match ExtraWhitespace /\s\+\%#\@<!$/]]) end,
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

-- Search with fzf-lua. Enter opens one result, or sends a multi-selection to
-- the quickfix list. Ctrl-q sends every result to the quickfix list.
local fzf = require('fzf-lua')
fzf.setup({
  defaults = { file_icons = false, git_icons = false },
  keymap = { fzf = { true, ['ctrl-q'] = 'select-all+accept' } },
  winopts = {
    on_create = function()
      -- The global <C-j>/<C-k> terminal mappings move between windows.
      -- Inside the fzf buffer, hand them back to fzf for list navigation.
      map('t', '<C-j>', '<Down>', { buffer = true })
      map('t', '<C-k>', '<Up>', { buffer = true })
    end,
  },
})
map('n', '<leader>t', fzf.files)
map('n', '<leader>a', fzf.live_grep)
map('n', '<leader>w', fzf.grep_cword)

-- Edit a file in the directory of the current file
map('', '<leader>e', ":e <C-R>=expand('%:p:h') . '/'<CR><CR>")
map('', '<leader>s', ":split <C-R>=expand('%:p:h') . '/'<CR><CR>")
map('', '<leader>v', ":vnew <C-R>=expand('%:p:h') . '/'<CR><CR>")

-- System clipboard
map('', '<leader>y', '"+y')
map('', '<leader>p', '"+p')

-- Move over screen lines, not buffer lines. Not in operator-pending mode,
-- so dj and yj stay linewise.
map({ 'n', 'x' }, 'k', 'gk')
map({ 'n', 'x' }, 'j', 'gj')

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

-- vim-test: run tests in a :terminal in a new tab
vim.g['test#strategy'] = 'neovim'
vim.g['test#neovim#term_position'] = 'tab'
map('n', '<leader>c', ':TestNearest<CR>', { silent = true })
map('n', '<leader>C', ':TestSuite<CR>', { silent = true })

-- Colors: overrides go in a ColorScheme autocmd so :colorscheme keeps them
local function apply_highlight_overrides()
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'Black', ctermbg = 'Black' })
  vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#222222' })
  vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = 'red', ctermbg = 'red' })
end
vim.api.nvim_create_autocmd('ColorScheme', { callback = apply_highlight_overrides })
vim.cmd.colorscheme('vividchalk')
match_trailing_whitespace()

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

-- LSP: configs come from nvim-lspconfig. Only enable servers that are
-- installed, otherwise Neovim logs an error on every matching buffer.
local servers = { expert = 'expert', gopls = 'gopls', ts_ls = 'typescript-language-server' }
for server, binary in pairs(servers) do
  if vim.fn.executable(binary) == 1 then
    vim.lsp.enable(server)
  end
end
