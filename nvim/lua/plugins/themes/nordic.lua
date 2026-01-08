return {
  'AlexvZyl/nordic.nvim',
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('nordic').setup({
      -- Enable bold keywords.
      bold_keywords = false,
      -- Enable italic comments.
      italic_comments = true,
      -- Enable editor background transparency.
      transparent = {
        -- Enable transparent background.
        bg = false,
        -- Enable transparent background for floating windows.
        float = false,
      },
      -- Enable brighter float border.
      bright_border = false,
      -- Reduce the overall amount of blue in the theme (diverges from base Nord).
      reduced_blue = true,
      -- Swap the dark background with the normal one.
      swap_backgrounds = false,
      -- Cursorline options.  Also includes visual/selection.
      cursorline = {
        -- Bold font in cursorline.
        bold = false,
        -- Bold cursorline number.
        bold_number = true,
        -- Available styles: 'dark', 'light'.
        theme = 'dark',
        -- Blending the cursorline bg with the buffer bg.
        blend = 0.85,
      },
      noice = {
        -- Available styles: `classic`, `flat`.
        style = 'classic',
      },
      telescope = {
        -- Available styles: `classic`, `flat`.
        style = 'flat',
      },
      leap = {
        -- Dims the backdrop when using leap.
        dim_backdrop = false,
      },
      ts_context = {
        -- Enables dark background for treesitter-context window
        dark_background = true,
      },
      -- Custom highlights for neo-tree
      on_highlight = function(highlights, palette)
        highlights.NeoTreeNormal = { bg = palette.bg_float }
        highlights.NeoTreeNormalNC = { bg = palette.bg_float }
        highlights.NeoTreeEndOfBuffer = { bg = palette.bg_float }
        highlights.NeoTreeCursorLine = { bg = palette.bg_visual }
      end,
    })

    local bg_transparent = false

    -- Toggle background transparency
    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      require('nordic').setup({
        transparent = {
          bg = bg_transparent,
          float = bg_transparent,
        },
      })
      require('nordic').load()
    end

    vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
  end,
}
