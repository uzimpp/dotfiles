return {
  'akinsho/bufferline.nvim',
  lazy = false, -- Load at startup for UI
  dependencies = {
    'moll/vim-bbye',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    -- vim.opt.linespace = 8

    require('bufferline').setup {
      options = {
        mode = 'buffers',                    -- set to "tabs" to only show tabpages instead
        themable = true,                     -- allows highlight groups to be overriden i.e. sets highlights as default
        numbers = 'none',                    -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        close_command = 'Bdelete! %d',       -- can be a string | function, see "Mouse actions"
        right_mouse_command = 'Bdelete! %d', -- can be a string | function, see "Mouse actions"
        left_mouse_command = 'buffer %d',    -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
        buffer_close_icon = '󰅖',
        -- buffer_close_icon = '✗',
        -- buffer_close_icon = '✕',
        close_icon = '',
        path_components = 1, -- Show only the file name without the directory
        modified_icon = '●',
        left_trunc_marker = '',
        right_trunc_marker = '',
        -- max_name_length = 30,
        -- max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
        -- tab_size = 23,
        diagnostics = false,
        diagnostics_update_in_insert = false,
        offsets = {
          {
            filetype = "neo-tree",
            -- text = " Explorer",
            -- text_align = "left", -- | "center" | "right"
            separator = false,
          }
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        separator_style = { '│', '│' }, -- | "thick" | "thin" | { 'any', 'any' },
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        show_tab_indicators = false,
        indicator = {
          -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
          style = 'none', -- Options: 'icon', 'underline', 'none'
        },
        icon_pinned = '󰐃',
        minimum_padding = 0,
        maximum_padding = 5,
        maximum_length = 15,
        sort_by = 'insert_at_end',
      },
      highlights = {
        buffer_selected = {
          bold = true,
          italic = false,
        },
        -- separator_selected = {},
        -- tab_selected = {},
        -- background = {},
        -- indicator_selected = {},
        -- fill = {},
      },
    }

    -- Buffer navigation keymaps
    local opts = { noremap = true, silent = true }

    -- Cycle through buffers
    vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
    vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Prev buffer' })

    -- Jump to buffer by number (leader + 1-9)
    vim.keymap.set('n', '<leader>1', function() require('bufferline').go_to(1, true) end, { desc = 'Buffer 1' })
    vim.keymap.set('n', '<leader>2', function() require('bufferline').go_to(2, true) end, { desc = 'Buffer 2' })
    vim.keymap.set('n', '<leader>3', function() require('bufferline').go_to(3, true) end, { desc = 'Buffer 3' })
    vim.keymap.set('n', '<leader>4', function() require('bufferline').go_to(4, true) end, { desc = 'Buffer 4' })
    vim.keymap.set('n', '<leader>5', function() require('bufferline').go_to(5, true) end, { desc = 'Buffer 5' })
    vim.keymap.set('n', '<leader>6', function() require('bufferline').go_to(6, true) end, { desc = 'Buffer 6' })
    vim.keymap.set('n', '<leader>7', function() require('bufferline').go_to(7, true) end, { desc = 'Buffer 7' })
    vim.keymap.set('n', '<leader>8', function() require('bufferline').go_to(8, true) end, { desc = 'Buffer 8' })
    vim.keymap.set('n', '<leader>9', function() require('bufferline').go_to(9, true) end, { desc = 'Buffer 9' })

    -- Move buffer position
    vim.keymap.set('n', '<leader>[', '<cmd>BufferLineMovePrev<CR>', { desc = 'Move buffer left' })
    vim.keymap.set('n', '<leader>]', '<cmd>BufferLineMoveNext<CR>', { desc = 'Move buffer right' })

    -- Pick buffer
    vim.keymap.set('n', '<leader>bp', '<cmd>BufferLinePick<CR>', { desc = 'Pick buffer' })
    vim.keymap.set('n', '<leader>bP', '<cmd>BufferLinePickClose<CR>', { desc = 'Pick buffer to close' })
  end,
}
