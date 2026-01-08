return {
  'evanlouie/cursor-dark-anysphere.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    -- Suppress ALL performance-related messages during theme setup
    local original_notify = vim.notify
    local original_print = print
    
    -- Override vim.notify to skip performance messages
    vim.notify = function(msg, level, opts)
      if type(msg) == 'string' and msg:find('Performance:') then return end
      if level == vim.log.levels.DEBUG then return end
      return original_notify(msg, level, opts)
    end
    
    -- Override print to skip performance messages
    print = function(...)
      local args = {...}
      if #args > 0 and type(args[1]) == 'string' and args[1]:find('Performance:') then return end
      return original_print(...)
    end

    require('cursor-dark-anysphere').setup({
      style = 'dark',
      transparent = true,
      transparency_mode = 'blended', -- 'blended' | 'transparent' | 'opaque'
      ending_tildes = false,
      cmp_itemkind_reverse = false,
      
      -- Disable transparency for floats and popups to prevent blue/purple tint
      transparencies = {
        floats = true,     -- Disable blend for floating windows (fixes blue/purple tint)
        popups = true,     -- Disable blend for popups
        sidebar = true,    -- Transparent sidebars
        statusline = true  -- Transparent statusline
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
        function_declarations = { bold = true },    -- Function definitions styling
        method_declarations = { bold = true },      -- Method definitions styling
        cpp_functions = { bold = true },            -- C/C++ function styling
        js_attributes = { italic = true },          -- JavaScript/TypeScript attributes
        ts_attributes = { italic = true },          -- TypeScript attributes
      },
      
      -- Semantic highlighting configuration
      semantic_highlighting = {
        enabled = true,                             -- Enable semantic token support
        languages = {
          c = true,                                 -- C language support
          cpp = true,                               -- C++ language support
          python = true,                            -- Python language support
          typescript = true,                        -- TypeScript language support
          javascript = true,                        -- JavaScript language support
        },
      },
      
      -- Override specific colors
      colors = {},
      
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
        trouble = false,
        todo_comments = true,
        lazy = true,
        mini = true,
        -- New plugin integrations
        copilot = true,                             -- GitHub Copilot AI assistance
        oil = true,                                 -- Oil file manager
        conform = true,                             -- Conform formatter
        noice = true,                               -- Noice UI enhancement
      },
    })

    -- Restore print (but keep vim.notify filter for performance messages)
    print = original_print
    
    -- Keep vim.notify filter permanently to catch async performance messages
    vim.notify = function(msg, level, opts)
      if type(msg) == 'string' and msg:find('Performance:') then return end
      if level == vim.log.levels.DEBUG then return end
      return original_notify(msg, level, opts)
    end

    -- Apply the colorscheme
    vim.cmd.colorscheme('cursor-dark-anysphere')

    -- Apply Neo-tree highlight overrides using anysphere colors
    local hl = vim.api.nvim_set_hl
    -- Anysphere palette:
    -- bg: #181818, fg: #d6d6dd, selection: #163761, blue: #61afef
    -- darkgray: #4b5261, gray: #b3b3b3, gray2: #5b5b5b
    hl(0, 'NeoTreeNormal', { bg = '#181818', fg = '#d6d6dd' })
    hl(0, 'NeoTreeNormalNC', { bg = '#181818', fg = '#d6d6dd' })
    hl(0, 'NeoTreeEndOfBuffer', { bg = '#181818', fg = '#181818' })
    hl(0, 'NeoTreeCursorLine', { bg = '#163761' }) -- selection color
    hl(0, 'NeoTreeWinSeparator', { fg = '#181818', bg = '#181818' })
    hl(0, 'NeoTreeIndentMarker', { fg = '#4b5261' }) -- darkgray
    hl(0, 'NeoTreeFileName', { fg = '#d6d6dd' })
    hl(0, 'NeoTreeDirectoryName', { fg = '#d6d6dd' })
    hl(0, 'NeoTreeDirectoryIcon', { fg = '#61afef' }) -- blue
    hl(0, 'NeoTreeRootName', { fg = '#d6d6dd', bold = true })
    hl(0, 'NeoTreeFloatBorder', { bg = '#181818', fg = '#4b5261' })
    hl(0, 'NeoTreeFloatTitle', { bg = '#181818', fg = '#d6d6dd' })
  end,
}
