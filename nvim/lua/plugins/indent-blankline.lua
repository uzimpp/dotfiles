return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  lazy = false,
  priority = 100,
  config = function()
    local hooks = require('ibl.hooks')
    local ibl = require('ibl')

    -- Single source of truth for ibl config
    local config = {
      indent = { char = '│', tab_char = '│' },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
        show_exact_scope = true,
        highlight = { 'Function', 'Label' },
      },
      whitespace = { remove_blankline_trail = true },
      exclude = {
        filetypes = {
          'help', 'startify', 'dashboard', 'alpha', 'packer',
          'neogitstatus', 'NvimTree', 'neo-tree', 'Trouble',
          'lazy', 'mason', 'notify', 'toggleterm', 'lazyterm',
        },
        buftypes = { 'terminal', 'nofile', 'quickfix', 'prompt' },
      },
    }

    ibl.setup(config)
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  end,
}
