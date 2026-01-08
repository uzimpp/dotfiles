return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  lazy = false,
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
    'hrsh7th/nvim-cmp',
  },
  config = function()
    require('noice').setup({
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
      -- Minimize notifications
      routes = {
        -- Skip performance profiling messages from theme
        {
          filter = {
            event = 'notify',
            find = 'Performance:',
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = 'msg_show',
            kind = 'error',
          },
          view = 'mini', -- Use mini view for errors
        },
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d+' },
              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
      },
      views = {
        popup = {
          border = { style = 'rounded' },
          win_options = { winblend = 0 },
        },
        notify = {
          border = { style = 'rounded' },
          win_options = { winblend = 0 },
          timeout = 2000, -- Shorter timeout
        },
        mini = {
          timeout = 2000, -- Shorter timeout for mini notifications
        },
      },
      -- Enable cmdline autocompletion
      cmdline = {
        enabled = true,
        view = 'cmdline_popup',
        format = {
          cmdline = { pattern = '^:', icon = '󰘳 ', lang = 'vim' },
          search_down = { kind = 'search', pattern = '^/', icon = '󰍉 ', lang = 'regex' },
          search_up = { kind = 'search', pattern = '^%?', icon = '󰍉 ', lang = 'regex' },
          filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
          lua = { pattern = '^:%s*lua%s+', icon = '󰢱 ', lang = 'lua' },
          help = { pattern = '^:%s*he?l?p?%s+', icon = '󰋽 ' },
        },
      },
    })
  end,
}
