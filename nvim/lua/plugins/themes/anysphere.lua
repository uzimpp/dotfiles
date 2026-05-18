return {
  'evanlouie/cursor-dark-anysphere.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('cursor-dark-anysphere').setup({
      style = 'dark',
      transparent = true,
      transparency_mode = 'blended', -- 'blended' | 'transparent' | 'opaque'
      ending_tildes = false,
      cmp_itemkind_reverse = false,

      -- Disable transparency for floats and popups to prevent blue/purple tint
      transparencies = {
        floats = true,    -- Disable blend for floating windows (fixes blue/purple tint)
        popups = true,    -- Disable blend for popups
        sidebar = true,   -- Transparent sidebars
        statusline = true -- Transparent statusline
      },

      -- Enhanced font styling options
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
        functions = { bold = true },
        variables = {},
        operators = {},
        booleans = {},
        strings = {},
        types = {},
        numbers = {},
        parameters = { italic = true },
        -- New font styling options
        function_declarations = { bold = true }, -- Function definitions styling
        method_declarations = { bold = true },   -- Method definitions styling
        cpp_functions = { bold = true },         -- C/C++ function styling
        js_attributes = { italic = true },       -- JavaScript/TypeScript attributes
        ts_attributes = { italic = true },       -- TypeScript attributes
      },

      -- Semantic highlighting configuration
      semantic_highlighting = {
        enabled = true,      -- Enable semantic token support
        languages = {
          c = true,          -- C language support
          cpp = true,        -- C++ language support
          python = true,     -- Python language support
          typescript = true, -- TypeScript language support
          javascript = true, -- JavaScript language support
          lua = true,        -- Lua language support
          go = true,         -- Go language support
        },
      },

      -- Override specific colors
      colors = {
        selection = '#3a3a3a',        -- #40404099 blended
        active_selection = '#3a3a3a', -- #ffffff1d blended
      },
      -- Override specific highlights
      highlights = {
        -- Neo-tree styling - darker background with visible selection
      },

      -- Plugin-specific settings (20+ plugins supported)
      plugins = {
        -- Core plugins
        telescope = true,
        nvim_tree = true,
        neo_tree = true,
        nvim_cmp = true,
        lualine = true,
        gitsigns = true,
        treesitter = true,
        indent_blankline = true,
        dashboard = true,
        which_key = true,
        trouble = true,
        todo_comments = true,
        lazy = true,
        mini = true,
        -- New plugin integrations
        copilot = true, -- GitHub Copilot AI assistance
        oil = true,     -- Oil file manager
        conform = true, -- Conform formatter
        noice = true,   -- Noice UI enhancement
      },
    })

    -- Restore print (but keep vim.notify filter for performance messages)
    print = original_print

    -- Keep vim.notify filter permanently to catch async messages
    vim.notify = function(msg, level, opts)
      if type(msg) == 'string' and (msg:find('Performance:') or msg:lower():find('load') or msg:lower():find('workspace')) then return end
      if level == vim.log.levels.DEBUG then return end
      return original_notify(msg, level, opts)
    end

    -- Apply the colorscheme
    vim.cmd.colorscheme('cursor-dark-anysphere')

    -- Apply highlight overrides using exact VSCode anysphere colors
    local hl = vim.api.nvim_set_hl

    -- NOTE: Custom config colors
    local c = {
      editor_bg = '#1a1a1a',
      ui_bg = '#141414',
      minimap_bg = '#181818',
      editor_fg = '#D8DEE9',
      ui_fg = '#CCCCCC',
      ui_fg_dim = '#7a7a7a', -- #FFFFFF5C blended
      gray1 = '#2A2A2A',
      gray2 = '#404040',
      gray3 = '#505050',
      gray4 = '#606060',
      gray5 = '#767676',
      blue1 = '#81A1C1',
      blue2 = '#88C0D0',
      blue3 = '#87c3ff',
      green1 = '#A3BE8C',
      green2 = '#a8cc7c',
      yellow1 = '#EBCB8B',
      red1 = '#BF616A',
      purple1 = '#B48EAD',
      pink = '#e394dc',
      selection = '#3a3a3a',        -- #40404099 blended
      active_selection = '#2d2d2d', -- #ffffff1d blended
      indent_guide = '#444444',     -- #CCCCCC55 blended
      sidebar_fg = '#E5E5E5',
    }

    -- Editor highlights
    hl(0, 'Normal', { bg = c.editor_bg, fg = c.editor_fg })
    hl(0, 'NormalNC', { bg = c.editor_bg, fg = c.editor_fg })
    local cursor_line_bg = c.editor_bg -- c.gray1 or c.editor_bg
    hl(0, 'CursorLine', { bg = cursor_line_bg })
    hl(0, 'CursorLineNr', { bg = cursor_line_bg, fg = c.sidebar_fg, bold = true, italic = true })
    hl(0, 'CursorLineSign', { bg = cursor_line_bg, fg = c.sidebar_fg })
    hl(0, 'LineNr', { fg = c.gray4 })
    hl(0, 'Visual', { bg = c.selection })
    hl(0, 'Search', { bg = '#4d6680', fg = c.editor_fg })
    hl(0, 'IncSearch', { bg = '#5a7a99', fg = c.editor_fg })

    -- Floating windows
    hl(0, 'NormalFloat', { bg = c.ui_bg, fg = c.editor_fg })
    hl(0, 'FloatBorder', { bg = c.ui_bg, fg = c.gray1 })
    hl(0, 'FloatTitle', { bg = c.ui_bg, fg = c.editor_fg, bold = true })

    -- Popup menus
    hl(0, 'Pmenu', { bg = c.ui_bg, fg = c.ui_fg })
    hl(0, 'PmenuSel', { bg = c.active_selection, fg = c.editor_fg })
    hl(0, 'PmenuSbar', { bg = c.gray1 })
    hl(0, 'PmenuThumb', { bg = c.gray3 })

    -- Cursor Integration
    hl(0, 'Cursor', { bg = c.pink, fg = c.ui_bg })
    hl(0, 'TermCursor', { bg = c.pink, fg = c.ui_bg })
    hl(0, 'TermCursorNC', { bg = c.pink, fg = c.ui_bg })

    -- Alpha Dashboard
    hl(0, 'AlphaBackground', { bg = c.ui_bg, fg = c.ui_fg })
    hl(0, 'AlphaHeader', { fg = c.blue1, bg = c.ui_bg })
    hl(0, 'AlphaButtons', { fg = c.ui_fg_dim, bg = c.ui_bg })
    hl(0, 'AlphaFooter', { fg = c.gray4, bg = c.ui_bg })

    -- Neo-tree
    hl(0, 'NeoTreeNormal', { bg = c.ui_bg, fg = c.ui_fg_dim })
    hl(0, 'NeoTreeNormalNC', { bg = c.ui_bg, fg = c.ui_fg_dim })
    hl(0, 'NeoTreeEndOfBuffer', { bg = c.ui_bg, fg = c.ui_bg })
    hl(0, 'NeoTreeCursorLine', { bg = c.active_selection })
    hl(0, 'NeoTreeWinSeparator', { fg = c.ui_bg, bg = c.ui_bg })
    hl(0, 'NeoTreeIndentMarker', { fg = c.indent_guide })
    hl(0, 'NeoTreeFileName', { fg = c.ui_fg_dim })
    hl(0, 'NeoTreeDirectoryName', { fg = c.ui_fg_dim })
    hl(0, 'NeoTreeDirectoryIcon', { fg = c.ui_fg_dim })
    hl(0, 'NeoTreeRootName', { fg = c.ui_fg_dim, bold = true })
    hl(0, 'NeoTreeFloatBorder', { bg = c.ui_bg, fg = c.gray1 })
    hl(0, 'NeoTreeFloatTitle', { bg = c.ui_bg, fg = c.ui_fg_dim })
    hl(0, 'NeoTreeGitAdded', { fg = c.green1 })
    hl(0, 'NeoTreeGitModified', { fg = c.yellow1 })
    hl(0, 'NeoTreeGitDeleted', { fg = c.red1 })
    hl(0, 'NeoTreeGitUntracked', { fg = c.green2 })

    -- Hidden / filtered items (visible = true shows these dimmed)
    hl(0, 'NeoTreeDimText', { fg = c.gray2 })                    -- general dim text
    hl(0, 'NeoTreeDotfile', { fg = c.gray2, italic = true })     -- dotfiles
    hl(0, 'NeoTreeHiddenByName', { fg = c.gray2, italic = true }) -- hide_by_name items
    hl(0, 'NeoTreeGitIgnored', { fg = c.gray2, italic = true })  -- git ignored
    hl(0, 'NeoTreeIgnored', { fg = c.gray2, italic = true })     -- .neotreeignore

    -- ── Telescope
    hl(0, "TelescopeNormal", { bg = c.ui_bg, fg = c.ui_fg_dim })
    hl(0, "TelescopeBorder", { bg = c.ui_bg, fg = c.gray1 })

    hl(0, "TelescopePromptNormal", { bg = c.ui_bg, fg = c.fg })
    hl(0, "TelescopePromptBorder", { bg = c.ui_bg, fg = c.gray1 })
    hl(0, "TelescopePromptTitle", { bg = c.ui_bg, fg = c.ui_fg })

    hl(0, "TelescopeResultsNormal", { bg = c.ui_bg, fg = c.ui_fg })
    hl(0, "TelescopeResultsBorder", { bg = c.ui_bg, fg = c.gray1 })
    hl(0, "TelescopeResultsTitle", { bg = c.ui_bg, fg = c.ui_fg })

    hl(0, "TelescopePreviewNormal", { bg = c.editor_bg })
    hl(0, "TelescopePreviewBorder", { bg = c.ui_bg, fg = c.gray1 })
    hl(0, "TelescopePreviewTitle", { bg = c.ui_bg, fg = c.ui_fg })
    hl(0, "TelescopePreviewMatch", { bg = c.active_selection, fg = c.blue3, bold = true })
    hl(0, "TelescopePreviewLine", { bg = c.active_selection })

    hl(0, "TelescopeSelection", { bg = c.active_selection })
    hl(0, "TelescopeSelectionCaret", { fg = c.ui_bg })
    hl(0, "TelescopeMatching", { fg = c.blue3, bold = true })

    -- Indent guides
    hl(0, 'IblIndent', { fg = c.gray2 })
    hl(0, 'IblScope', { fg = c.indent_guide })

    -- Statusline
    hl(0, 'StatusLine', { bg = c.ui_bg, fg = c.ui_fg_dim })
    hl(0, 'StatusLineNC', { bg = c.ui_bg, fg = c.gray4 })

    -- Rainbow Delimiters (Anysphere Palette)
    hl(0, 'RainbowDelimiterYellow', { fg = c.yellow1 })
    hl(0, 'RainbowDelimiterBlue', { fg = c.blue1 })
    hl(0, 'RainbowDelimiterOrange', { fg = c.red1 })
    hl(0, 'RainbowDelimiterGreen', { fg = c.green1 })
    hl(0, 'RainbowDelimiterViolet', { fg = c.purple1 })
    hl(0, 'RainbowDelimiterCyan', { fg = c.blue2 })
    hl(0, 'RainbowDelimiterRed', { fg = c.red1 })

    -- Bufferline Integration
    hl(0, 'BufferLineFill', { bg = c.ui_bg })
    hl(0, 'BufferLineBackground', { bg = c.ui_bg, fg = c.ui_fg_dim })
    hl(0, 'BufferLineSeparator', { bg = c.ui_bg, fg = c.ui_bg })
    hl(0, 'BufferLineBufferSelected', { bg = c.editor_bg, fg = c.editor_fg, bold = true })

    -- Lualine highlight (deferred so lualine is guaranteed loaded, same as mellifluous)
    vim.schedule(function()
      local lualine_theme = {
        normal = {
          a = { bg = c.blue1, fg = c.ui_bg, gui = 'bold' },
          b = { bg = c.gray1, fg = c.blue1 },
          c = { bg = c.ui_bg, fg = c.ui_fg_dim }
        },
        insert = {
          a = { bg = c.green1, fg = c.ui_bg, gui = 'bold' },
          b = { bg = c.gray1, fg = c.green1 },
          c = { bg = c.ui_bg, fg = c.ui_fg_dim }
        },
        visual = {
          a = { bg = c.pink, fg = c.ui_bg, gui = 'bold' },
          b = { bg = c.gray1, fg = c.pink },
          c = { bg = c.ui_bg, fg = c.ui_fg_dim }
        },
        replace = {
          a = { bg = c.red1, fg = c.ui_bg, gui = 'bold' },
          b = { bg = c.gray1, fg = c.red1 },
          c = { bg = c.ui_bg, fg = c.ui_fg_dim }
        },
        command = {
          a = { bg = c.yellow1, fg = c.ui_bg, gui = 'bold' },
          b = { bg = c.gray1, fg = c.yellow1 },
          c = { bg = c.ui_bg, fg = c.ui_fg_dim }
        },
        inactive = {
          a = { bg = c.ui_bg, fg = c.ui_bg },
          b = { bg = c.ui_bg, fg = c.ui_bg },
          c = { bg = c.ui_bg, fg = c.ui_bg }
        }
      }

      package.loaded['lualine.themes.cursor-dark-anysphere'] = lualine_theme
      if package.loaded['lualine'] then
        require('lualine').setup({ options = { theme = lualine_theme } })
      end
    end)
  end,
}
