return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('tokyonight').setup({
      style = 'night', -- storm, moon, night, day
      light_style = 'day',
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = 'dark', -- dark, transparent, normal
        floats = 'dark', -- dark, transparent, normal
      },
      day_brightness = 0.3,
      dim_inactive = false,
      lualine_bold = false,

      -- Custom color overrides
      on_colors = function(colors)
        -- You can override specific colors here
        -- colors.bg = '#1a1b26'
      end,

      -- Custom highlight overrides
      on_highlights = function(hl, c)
        -- Make neo-tree background darker than normal background
        hl.NeoTreeNormal = { bg = c.bg_dark, fg = c.fg_sidebar }
        hl.NeoTreeNormalNC = { bg = c.bg_dark, fg = c.fg_sidebar }
        hl.NeoTreeEndOfBuffer = { bg = c.bg_dark, fg = c.bg_dark }
        hl.NeoTreeCursorLine = { bg = c.bg_highlight }
        hl.NeoTreeWinSeparator = { fg = c.bg_dark, bg = c.bg_dark }
        hl.NeoTreeIndentMarker = { fg = c.fg_gutter }
        hl.NeoTreeDirectoryIcon = { fg = c.blue }
        hl.NeoTreeRootName = { fg = c.fg_sidebar, bold = true }
        hl.NeoTreeFloatBorder = { bg = c.bg_dark, fg = c.border }
        hl.NeoTreeFloatTitle = { bg = c.bg_dark, fg = c.fg_sidebar }
        hl.NeoTreeGitAdded = { fg = c.green }
        hl.NeoTreeGitModified = { fg = c.yellow }
        hl.NeoTreeGitDeleted = { fg = c.red }
        hl.NeoTreeGitUntracked = { fg = c.teal }

        -- Floating windows
        hl.NormalFloat = { bg = c.bg_dark, fg = c.fg }
        hl.FloatBorder = { bg = c.bg_dark, fg = c.border }
        hl.FloatTitle = { bg = c.bg_dark, fg = c.fg, bold = true }

        -- Popup menus
        hl.Pmenu = { bg = c.bg_dark, fg = c.fg }
        hl.PmenuSel = { bg = c.bg_highlight, fg = c.fg }
        hl.PmenuSbar = { bg = c.bg_highlight }
        hl.PmenuThumb = { bg = c.fg_gutter }
      end,

      cache = true,

      -- Plugin integrations
      plugins = {
        auto = true,
        all = false,
        telescope = true,
        cmp = true,
        gitsigns = true,
        treesitter = true,
        notify = true,
        mini = true,
        neotree = true,
        indent_blankline = true,
        which_key = true,
        trouble = true,
        lazy = true,
        noice = true,
      },
    })

    -- Don't call colorscheme here - init.lua handles theme application

    -- Toggle background transparency
    local bg_transparent = true
    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      require('tokyonight').setup({
        transparent = bg_transparent,
      })
      vim.cmd.colorscheme('tokyonight')
    end

    vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
  end,
}

