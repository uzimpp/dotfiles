return {
  'ramojus/mellifluous.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('mellifluous').setup({
      colorset = 'mellifluous',
      -- modify some colors for mellifluous colorset
      mellifluous = {
        color_overrides = {
          dark = {
            colors = function(colors)
              return {
              }
            end,
          },
        },
      },
      styles = {
        comments = { italic = true },
        strings = { },
        variables = { },
        numbers = {},
        booleans = {  },
        properties = { },
        types = {  },
        main_keywords = { bold = true },
        other_keywords = { },
        operators = { },
        functions = { },
        constants = { },
      },

      transparent_background = {

      },

      flat_background = {

      },

      plugins = {
        cmp = true,
        gitsigns = true,
        indent_blankline = true,
        nvim_tree = { enabled = true },
        neo_tree = { enabled = true },
        telescope = { enabled = true },
        treesitter = { enabled = true, colored_brackets = true },
      },
    })

    vim.cmd.colorscheme('mellifluous')

    vim.schedule(function()
      local hl = vim.api.nvim_set_hl

      local c = {
          -- Backgrounds
          bg = "#1a1a1a",         -- Normal / default background (editor)
          ui_bg = "#141414",     -- Darker background (NeoTree, LineNr, floats)
          bg_bright = "#242424",  -- Lighter background (Telescope, active lines)
          bg_visual = "#2d2d2d",  -- Visual selection, Pmenu
          bg_search = "#373737",  -- Search, Telescope Selection
          -- Foregrounds
          fg = "#CCCCCC",         -- Normal text
          fg_dark = "#AEAEAE",    -- Dimmed text (Telescope Normal, comments sometimes)
          fg_dim = "#515151",     -- Very dim (LineNr, out of focus)
          fg_gutter = "#4d4d4d",  -- Gutter/Conceal
          -- Accents / Syntax
          red = "#d59192",        -- Errors, keywords
          orange = "#cbaa88",     -- Main keywords, accent, alpha header
          yellow = "#bfb68e",     -- Strings, warnings
          green = "#97b393",      -- Additions, strings sometimes
          blue = "#a8a1be",       -- Functions
          purple = "#b99bb5",    -- Constants, hints
          -- Borders
          border = "#282828",
          -- Specific overrides
          comment = "#564e49",
          white = "#e9e6d8"
      }

      -- ── General Overrides ───────────────────────────────────────────
      hl(0, "Cursor", { bg = c.white, fg = c.bg })
      hl(0, "TermCursor", { link = "Cursor" })
      hl(0, "Comment", { fg = c.comment, italic = true })
      hl(0, "@comment", { link = "Comment" })
      hl(0, "ColorColumn", { bg = c.ui_bg })
      hl(0, "VertSplit", { bg = c.bg, fg = c.fg_gutter })
      hl(0, "LineNr", { bg = c.bg, fg = c.fg_dim })
      hl(0, "CursorLineNr", { bg = c.bg, fg = c.white, bold = true, italic = true })
      hl(0, "CursorColumn", { bg = c.bg_bright })
      hl(0, "SignColumn", { bg = c.bg, fg = c.fg_gutter })
      hl(0, "GitSignsAdd", { bg = c.bg, fg = c.green })
      hl(0, "GitSignsChange", { bg = c.bg, fg = c.yellow })
      hl(0, "GitSignsDelete", { bg = c.bg, fg = c.red })
      hl(0, 'CursorLine', { bg = c.bg })

      -- ── Diagnostics ──────────────────────────────────────────────────
      hl(0, "DiagnosticSignWarn", { bg = c.bg_ui, fg = c.orange })
      hl(0, "DiagnosticSignError", { bg = c.bg_ui, fg = c.red })
      hl(0, "DiagnosticSignInfo", { bg = c.bg_ui, fg = c.blue })
      hl(0, "DiagnosticSignHint", { bg = c.bg_ui, fg = c.purple })
      hl(0, "DiagnosticSignOk", { bg = c.bg_ui, fg = c.green })

      -- ── Alpha Dashboard ─────────────────────────────────────────────
      hl(0, 'AlphaBackground', { bg = c.ui_bg, fg = c.fg })
      hl(0, 'AlphaHeader', { fg = c.red, bg = c.ui_bg })
      hl(0, 'AlphaButtons', { fg = c.fg_gutter, bg = c.ui_bg , italic = true})
      hl(0, 'AlphaFooter', { fg = c.fg_gutter, bg = c.ui_bg })

      -- ── Neo-tree ─────────────────────────────────────────
      hl(0, 'NeoTreeNormal', { bg = c.ui_bg, fg = c.fg_dim })
      hl(0, 'NeoTreeNormalNC', { bg = c.ui_bg, fg = c.fg_dim })
      hl(0, 'NeoTreeEndOfBuffer', { bg = c.ui_bg, fg = c.ui_bg })
      hl(0, 'NeoTreeCursorLine', { bg = c.bg_visual })
      hl(0, 'NeoTreeWinSeparator', { fg = c.ui_bg, bg = c.ui_bg })
      hl(0, 'NeoTreeIndentMarker', { fg = c.fg_dim })
      hl(0, 'NeoTreeFileName', { fg = c.fg_dim })
      hl(0, 'NeoTreeDirectoryName', { fg = c.fg_dim })
      hl(0, 'NeoTreeDirectoryIcon', { fg = c.fg_dim })
      hl(0, 'NeoTreeRootName', { fg = c.orange, bold = true })
      hl(0, 'NeoTreeFloatBorder', { bg = c.ui_bg, fg = c.border })
      hl(0, 'NeoTreeFloatTitle', { bg = c.ui_bg, fg = c.fg })
      hl(0, 'NeoTreeGitAdded', { fg = c.green })
      hl(0, 'NeoTreeGitModified', { fg = c.yellow })
      hl(0, 'NeoTreeGitDeleted', { fg = c.red })
      hl(0, 'NeoTreeGitUntracked', { fg = c.purple })

      hl(0, 'NeoTreeDimText',     { fg = c.fg_gutter })
      hl(0, 'NeoTreeDotfile',     { fg = c.fg_gutter, })
      hl(0, 'NeoTreeHiddenByName',{ fg = c.fg_gutter, })
      hl(0, 'NeoTreeGitIgnored',  { fg = c.fg_gutter, })
      hl(0, 'NeoTreeIgnored',     { fg = c.fg_gutter, })

      -- ── Telescope ───────────────────────────────────────────────────
      hl(0, "TelescopeNormal", { bg = c.ui_bg, fg = c.fg_dim })
      hl(0, "TelescopeBorder", { fg = c.ui_bg, bg = c.ui_bg })

      hl(0, "TelescopePromptNormal", { bg = c.ui_bg, fg = c.fg })
      hl(0, "TelescopePromptBorder", { bg = c.ui_bg, fg = c.border })
      hl(0, "TelescopePromptTitle", { bg = c.ui_bg, fg = c.fg_dark })

      hl(0, "TelescopeResultsNormal", { bg = c.ui_bg, fg = c.fg_dark })
      hl(0, "TelescopeResultsBorder", { bg = c.ui_bg, fg = c.border })
      hl(0, "TelescopeResultsTitle", { bg = c.ui_bg, fg = c.fg_dark })
      hl(0, "TelescopeResultsLineNr", { bg = c.ui_bg, fg = c.fg_dim })
      hl(0, "TelescopeResultsNumber", { fg = c.purple })
      hl(0, "TelescopeResultsOperator", { fg = c.cyan })
      hl(0, "TelescopeResultsVariable", { fg = c.orange })

      hl(0, "TelescopePreviewNormal", { bg = c.bg })
      hl(0, "TelescopePreviewBorder", { bg = c.ui_bg, fg = c.border })
      hl(0, "TelescopePreviewTitle", { bg = c.ui_bg, fg = c.fg_dark })
      hl(0, "TelescopePreviewMatch", { bg = c.bg_visual, fg = c.orange })
      hl(0, "TelescopePreviewLine", { bg = c.bg_visual })

      hl(0, "TelescopeSelection", { bg = c.bg_visual })
      hl(0, "TelescopeSelectionCaret", { fg = c.ui_bg })
      hl(0, "TelescopeMatching", { fg = c.orange, bold = true })

      -- ── Cmp ─────────────────────────────────────────────────────────
      hl(0, "CmpDocumentationBorder", { bg = c.bg_visual })
      hl(0, "CmpItemAbbr", { fg = c.fg_dark })
      hl(0, "CmpItemAbbrDeprecated", { fg = c.comment })
      hl(0, "CmpItemAbbrMatch", { fg = c.fg })
      hl(0, "CmpItemKind", { fg = c.cyan })

      -- ── WhichKey ────────────────────────────────────────────────────
      -- Provide some readable WhichKey highlighting that stands out cleanly
      hl(0, "WhichKey", { fg = c.cyan, bold = true })                -- The key itself
      hl(0, "WhichKeyGroup", { fg = c.blue })           -- A group of keys
      hl(0, "WhichKeyDesc", { fg = c.purple })         -- The description of the key
      hl(0, "WhichKeySeparator", { fg = c.fg_gutter })  -- The separator between key and desc
      hl(0, "WhichKeyFloat", { bg = c.ui_bg })         -- Background of the floating window
      hl(0, "WhichKeyNormal", { bg = c.ui_bg })        -- Background of the window (newer WhichKey versions)
      hl(0, "WhichKeyBorder", { fg = c.border, bg = c.ui_bg }) -- Border of the window
      hl(0, "WhichKeyValue", { fg = c.fg_dark })

      -- ── Lualine ─────────────────────────────────────────────────────
      hl(0, 'NotifyBackground',   { bg = c.bg, fg = c.fg })

      -- ── Noice ─────────────────────────────────────────────────────
      hl(0, "NoicePopup", { bg = c.ui_bg, fg = c.fg })
      hl(0, "NoiceCmdlinePopup", { bg = c.ui_bg, fg = c.fg })

      local lualine_theme = {
        normal = {
          a = { bg = c.blue, fg = c.bg},
          b = { bg = c.bg_visual, fg = c.blue },
          c = { bg = c.ui_bg, fg = c.fg_dim }
        },
        insert = {
          a = { bg = c.green, fg = c.bg},
          b = { bg = c.bg_visual, fg = c.green },
          c = { bg = c.ui_bg, fg = c.fg_dim }
        },
        visual = {
          a = { bg = c.purple, fg = c.bg},
          b = { bg = c.bg_visual, fg = c.purple },
          c = { bg = c.ui_bg, fg = c.fg_dim }
        },
        replace = {
          a = { bg = c.yellow, fg = c.bg},
          b = { bg = c.bg_visual, fg = c.yellow },
          c = { bg = c.ui_bg, fg = c.fg_dim }
        },
        command = {
          a = { bg = c.orange, fg = c.bg},
          b = { bg = c.bg_visual, fg = c.orange },
          c = { bg = c.ui_bg, fg = c.fg_dim }
        },
        inactive = {
          a = { bg = c.ui_bg, fg = c.ui_bg },
          b = { bg = c.ui_bg, fg = c.ui_bg },
          c = { bg = c.ui_bg, fg = c.ui_bg }
        }
      }

      package.loaded['lualine.themes.mellifluous'] = lualine_theme
      if package.loaded['lualine'] then
        require('lualine').setup({ options = { theme = lualine_theme } })
      end
    end)


    -- Toggle transparency
    local bg_transparent = true
    vim.keymap.set('n', '<leader>bg', function()
      bg_transparent = not bg_transparent
      require('mellifluous').setup({
        transparent_background = { enabled = bg_transparent },
      })
      vim.cmd.colorscheme('mellifluous')
    end, { noremap = true, silent = true, desc = 'Toggle transparency' })
  end,
}
