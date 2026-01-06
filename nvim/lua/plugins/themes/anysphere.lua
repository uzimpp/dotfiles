return {
  'evanlouie/cursor-dark-anysphere.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('cursor-dark-anysphere').setup({
      -- Transparency mode: 'opaque', 'blend', or 'transparent'
      transparency_mode = 'transparent',
      
      -- Enable semantic highlighting
      semantic_highlighting = {
        enabled = true,
        languages = {
          c = true,
          cpp = true,
          python = true,
          typescript = true,
          javascript = true,
        },
      },
      
      -- Font styling options
      styles = {
        function_declarations = { bold = true },
        method_declarations = { bold = true },
        parameters = { italic = true },
        comments = { italic = true },
        cpp_functions = { bold = true },
        js_attributes = { italic = true },
        ts_attributes = { italic = true },
      },
      
      -- Plugin integrations
      plugins = {
        -- Core plugins
        nvim_tree = true,
        neo_tree = true,
        oil = true,
        telescope = true,
        cmp = true,
        gitsigns = true,
        lualine = true,
        treesitter = true,
        indent_blankline = true,
        dashboard = true,
        which_key = true,
        noice = true,
        trouble = true,
        todo_comments = true,
        lazy = true,
        
        -- Development & Productivity
        dap = true,
        copilot = true,
        conform = true,
      },
    })
    
    -- Configure theme - init.lua will load it based on THEME env var
    -- Don't call colorscheme here - let init.lua handle it
    
    -- Toggle background transparency
    local bg_transparent = true
    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      local mode = bg_transparent and 'transparent' or 'opaque'
      require('cursor-dark-anysphere').setup({
        transparency_mode = mode,
      })
      vim.cmd.colorscheme 'cursor-dark-anysphere'
    end
    
    vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
  end,
}

