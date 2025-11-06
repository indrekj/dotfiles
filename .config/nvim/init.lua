-- Load my old vimscript settings
vim.cmd('source ~/.config/nvim/old-init.vim')

-- Set up nvim-cmp.
local cmp = require('cmp')

cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
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
    ['<C-Space>'] = cmp.mapping.complete()
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }
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
        end
      }
    }
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Set up command-line completion
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Show diagnostic on hover
vim.api.nvim_create_autocmd('CursorHold', {
  pattern = '*',
  callback = function()
    vim.diagnostic.open_float(nil, {
      scope = "cursor", -- Only show diagnostics for the current cursor position
      focusable = false, -- Make the popup non-interactive
    })
  end
})

vim.diagnostic.config({
  float = {
    border = "rounded",
    winhighlight = "Normal:DiagnosticFloat",
  },
})

-- Enable Elixir Expert language server
vim.lsp.config('expert', {
  cmd = { 'expert', '--stdio' },
  root_markers = { 'mix.exs', '.git' },
  filetypes = { 'elixir', 'eelixir', 'heex' },
})
vim.lsp.enable('expert')
