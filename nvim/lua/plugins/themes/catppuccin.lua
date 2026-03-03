return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  config = function()
    require('catppuccin').setup({
      flavour = 'mocha', -- latte, frappe, macchiato, mocha
      background = {
        light = 'mocha',
        dark = 'mocha',
      },
      transparent_background = true, -- disables setting the background color
      float = {
        transparent = true, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
      },
      show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
      term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = 'dark',
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      no_underline = false, -- Force no underline
      styles = { -- Handles the styles of general hi groups (see `:h highlight-args`)
        comments = { 'italic' }, -- Change the style of comments
        conditionals = { 'italic' },
        loops = {},
        functions = { 'bold' },
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
      },
      lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`)
        virtual_text = {
          errors = { 'italic' },
          hints = { 'italic' },
          warnings = { 'italic' },
          information = { 'italic' },
          ok = { 'italic' },
        },
        underlines = {
          errors = { 'underline' },
          hints = { 'underline' },
          warnings = { 'underline' },
          information = { 'underline' },
          ok = { 'underline' },
        },
        inlay_hints = {
          background = true,
        },
      },
      color_overrides = {},
      custom_highlights = function(colors)
        return {
          -- Editor background (base)
          Normal = { bg = colors.base, fg = colors.text },
          NormalNC = { bg = colors.base, fg = colors.subtext1 },

          -- Neo-tree styling - darker background (mantle) for sidebar
          NeoTreeNormal = { bg = colors.mantle, fg = colors.text },
          NeoTreeNormalNC = { bg = colors.mantle, fg = colors.subtext1 },
          NeoTreeEndOfBuffer = { bg = colors.mantle, fg = colors.mantle },
          NeoTreeCursorLine = { bg = colors.surface0 },
          NeoTreeWinSeparator = { fg = colors.mantle, bg = colors.mantle },
          NeoTreeIndentMarker = { fg = colors.surface1 },
          NeoTreeFileName = { fg = colors.text },
          NeoTreeDirectoryName = { fg = colors.text },
          NeoTreeDirectoryIcon = { fg = colors.blue },
          NeoTreeRootName = { fg = colors.text, bold = true },
          NeoTreeFloatBorder = { bg = colors.mantle, fg = colors.surface1 },
          NeoTreeFloatTitle = { bg = colors.mantle, fg = colors.text },
          NeoTreeGitAdded = { fg = colors.green },
          NeoTreeGitModified = { fg = colors.yellow },
          NeoTreeGitDeleted = { fg = colors.red },
          NeoTreeGitUntracked = { fg = colors.teal },

          -- Floating windows (crust - darkest)
          NormalFloat = { bg = colors.crust, fg = colors.text },
          FloatBorder = { bg = colors.crust, fg = colors.surface1 },
          FloatTitle = { bg = colors.crust, fg = colors.text, bold = true },

          -- Popup menus (crust with different selection)
          Pmenu = { bg = colors.crust, fg = colors.subtext1 },
          PmenuSel = { bg = colors.surface0, fg = colors.text },
          PmenuSbar = { bg = colors.surface0 },
          PmenuThumb = { bg = colors.surface2 },
          PmenuKind = { bg = colors.crust, fg = colors.mauve },
          PmenuExtra = { bg = colors.crust, fg = colors.subtext0 },

          -- Cursor and selection
          CursorLine = { bg = colors.surface0 },
          CursorColumn = { bg = colors.surface0 },
          CursorLineNr = { fg = colors.text, bold = true },
          LineNr = { fg = colors.surface1 },
          Visual = { bg = colors.surface1 },
          VisualNOS = { bg = colors.surface1 },
          Search = { bg = colors.surface2, fg = colors.text },
          IncSearch = { bg = colors.peach, fg = colors.base },
          CurSearch = { bg = colors.yellow, fg = colors.base },

          -- Indent guides
          IblIndent = { fg = colors.surface0 },
          IblScope = { fg = colors.surface2 },

          -- Statusline (mantle - different from editor)
          StatusLine = { bg = colors.mantle, fg = colors.subtext0 },
          StatusLineNC = { bg = colors.mantle, fg = colors.surface1 },
          WinBar = { bg = colors.mantle, fg = colors.subtext0 },
          WinBarNC = { bg = colors.mantle, fg = colors.surface1 },

          -- Window separator
          WinSeparator = { fg = colors.surface0, bg = colors.base },

          -- Tabline
          TabLine = { bg = colors.mantle, fg = colors.subtext0 },
          TabLineSel = { bg = colors.surface0, fg = colors.text },
          TabLineFill = { bg = colors.mantle, fg = colors.subtext0 },

          -- Command line
          CmdLine = { bg = colors.crust, fg = colors.text },
          CmdLineBorder = { bg = colors.crust, fg = colors.surface1 },

          -- Quickfix and location lists
          QuickFixLine = { bg = colors.surface0, bold = true },
          qfLineNr = { fg = colors.mauve },
          qfFileName = { fg = colors.blue },

          -- Telescope (crust background)
          TelescopeBorder = { bg = colors.crust, fg = colors.surface1 },
          TelescopeNormal = { bg = colors.crust },
          TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
          TelescopePromptNormal = { bg = colors.surface0 },
          TelescopePromptTitle = { bg = colors.mauve, fg = colors.crust, bold = true },
          TelescopePreviewTitle = { bg = colors.green, fg = colors.crust, bold = true },
          TelescopeResultsTitle = { bg = colors.crust, fg = colors.crust },
          TelescopeSelection = { bg = colors.surface0 },
          TelescopeSelectionCaret = { bg = colors.surface0, fg = colors.mauve },

          -- Which-key (crust background)
          WhichKeyFloat = { bg = colors.crust },
          WhichKeyBorder = { bg = colors.crust, fg = colors.surface1 },
          WhichKey = { fg = colors.mauve },
          WhichKeyGroup = { fg = colors.blue },
          WhichKeySeparator = { fg = colors.surface1 },
          WhichKeyDesc = { fg = colors.text },
          WhichKeyValue = { fg = colors.subtext0 },

          -- Noice (notification UI)
          NoiceCmdline = { bg = colors.crust },
          NoiceCmdlineIcon = { fg = colors.mauve },
          NoiceCmdlineIconSearch = { fg = colors.yellow },
          NoiceCmdlinePopup = { bg = colors.crust },
          NoiceCmdlinePopupBorder = { bg = colors.crust, fg = colors.surface1 },
          NoiceNotify = { bg = colors.crust },
          NoiceNotifyBorder = { bg = colors.crust, fg = colors.surface1 },

          -- Notify
          NotifyBackground = { bg = colors.crust },
          NotifyBorder = { bg = colors.crust, fg = colors.surface1 },

          -- LSP and diagnostics
          DiagnosticVirtualTextError = { bg = colors.base, fg = colors.red },
          DiagnosticVirtualTextWarn = { bg = colors.base, fg = colors.yellow },
          DiagnosticVirtualTextInfo = { bg = colors.base, fg = colors.blue },
          DiagnosticVirtualTextHint = { bg = colors.base, fg = colors.teal },

          -- CMP (completion menu)
          CmpItemAbbr = { fg = colors.subtext1 },
          CmpItemAbbrMatch = { fg = colors.blue, bold = true },
          CmpItemAbbrMatchFuzzy = { fg = colors.blue, bold = true },
          CmpItemMenu = { fg = colors.mauve },
          CmpItemKind = { fg = colors.mauve },
        }
      end,
      default_integrations = true,
      auto_integrations = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true,
        treesitter = true,
        telescope = { enabled = true },
        which_key = true,
        indent_blankline = { enabled = true },
        notify = false,
        noice = true,
        mini = {
          enabled = true,
          indentscope_color = '',
        },
      },
    })

    -- Apply colorscheme
    vim.cmd.colorscheme('catppuccin')

    -- Get catppuccin colors for lualine theme
    local colors = require('catppuccin.palettes').get_palette('mocha')

    -- Expose lualine theme globally for lualine.lua to use
    vim.g.catppuccin_lualine = {
      normal = {
        a = { bg = colors.blue, fg = colors.crust, gui = 'bold' },
        b = { bg = colors.surface0, fg = colors.blue },
        c = { bg = colors.crust, fg = colors.subtext0 },
      },
      insert = {
        a = { bg = colors.green, fg = colors.crust, gui = 'bold' },
        b = { bg = colors.surface0, fg = colors.green },
        c = { bg = colors.crust, fg = colors.subtext0 },
      },
      visual = {
        a = { bg = colors.mauve, fg = colors.crust, gui = 'bold' },
        b = { bg = colors.surface0, fg = colors.mauve },
        c = { bg = colors.crust, fg = colors.subtext0 },
      },
      replace = {
        a = { bg = colors.red, fg = colors.crust, gui = 'bold' },
        b = { bg = colors.surface0, fg = colors.red },
        c = { bg = colors.crust, fg = colors.subtext0 },
      },
      command = {
        a = { bg = colors.peach, fg = colors.crust, gui = 'bold' },
        b = { bg = colors.surface0, fg = colors.peach },
        c = { bg = colors.crust, fg = colors.subtext0 },
      },
      inactive = {
        a = { bg = colors.crust, fg = colors.subtext0 },
        b = { bg = colors.crust, fg = colors.subtext0 },
        c = { bg = colors.crust, fg = colors.subtext0 },
      },
    }

    -- Toggle background transparency
    local bg_transparent = true
    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      require('catppuccin').setup({
        transparent_background = bg_transparent,
      })
      vim.cmd.colorscheme('catppuccin')
    end

    vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
  end,
}
