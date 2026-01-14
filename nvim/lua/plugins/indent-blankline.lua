return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  lazy = false, -- Load immediately
  priority = 100,
  config = function()
    -- Get theme colors if available
    local hooks = require('ibl.hooks')

    -- Setup indent-blankline
    require('ibl').setup({
      indent = {
        char = '│', -- Thinner line like VSCode
        tab_char = '│',
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
        show_exact_scope = true,
        highlight = { 'Function', 'Label' },
      },
      whitespace = {
        remove_blankline_trail = true,
      },
      exclude = {
        filetypes = {
          'help',
          'startify',
          'dashboard',
          'alpha',
          'packer',
          'neogitstatus',
          'NvimTree',
          'neo-tree',
          'Trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
        },
        buftypes = {
          'terminal',
          'nofile',
          'quickfix',
          'prompt',
        },
      },
    })

    -- Use treesitter scope highlighting
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  end,
}
