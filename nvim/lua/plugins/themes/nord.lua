return {
  'shaunsingh/nord.nvim',
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- Example config in lua
    vim.g.nord_contrast = true                   -- Make sidebars and popup menus like nvim-tree and telescope have a different background
    vim.g.nord_borders = false                   -- Enable the border between verticaly split windows visable
    vim.g.nord_disable_background = true         -- Disable the setting of background color so that NeoVim can use your terminal background
    vim.g.set_cursorline_transparent = false     -- Set the cursorline transparent/visible
    vim.g.nord_italic = false                    -- enables/disables italics
    vim.g.nord_enable_sidebar_background = false -- Re-enables the background of the sidebar if you disabled the background of everything
    vim.g.nord_uniform_diff_background = true    -- enables/disables colorful backgrounds when used in diff mode
    vim.g.nord_bold = false                      -- enables/disables bold

    -- Make neo-tree background darker (nord_contrast already helps, but add custom highlights)
    vim.defer_fn(function()
      -- Nord uses darker colors for sidebars when contrast is enabled
      -- Add additional custom highlights for neo-tree
      vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = '#2E3440' }) -- darker than base #3B4252
      vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { bg = '#2E3440' })
      vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { bg = '#2E3440' })
      vim.api.nvim_set_hl(0, 'NeoTreeCursorLine', { bg = '#3B4252' })
    end, 100)

    local bg_transparent = true

    -- Toggle background transparency
    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      vim.g.nord_disable_background = bg_transparent
      vim.cmd [[colorscheme nord]]
    end

    vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
  end,
}
