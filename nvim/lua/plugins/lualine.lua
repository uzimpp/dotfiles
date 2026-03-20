return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  priority = 1000,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local mode = {
      'mode',
      fmt = function(str)
        return '' .. str
      end,
    }

    local filename = {
      'filename',
      file_status = true,
      path = 0,
    }

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 20
    end

    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      sections = { 'error', 'warn' },
      symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰌵 ' },
      colored = true,
      update_in_insert = true,
      always_visible = true,
      cond = hide_in_width,
    }

    local diff = {
      'diff',
      colored = true,
      symbols = { added = '+', modified = '~', removed = '-' },
      cond = hide_in_width,
    }
    -- TODO
    -- Git blame component using git-blame.nvim (like VS Code GitLens)
    local git_blame = {
      function()
        local gitblame = require('gitblame')
        return gitblame.get_current_blame_text()
      end,
      cond = function()
        local ok, gitblame = pcall(require, 'gitblame')
        return ok and gitblame.is_blame_text_available()
      end,
    }

    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = 'auto',
        -- https://www.nerdfonts.com/cheat-sheet
        --             ▓▒░ ░▒▓
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { 'alpha' },
        globalstatus = true,
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { 'branch', diff },
        lualine_c = { filename, diagnostics },
        lualine_x = { git_blame  },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = { mode },
        lualine_b = { { 'filename', path = 1 } },
        lualine_c = {},
        lualine_x = { { 'filetype', icon_only = false } },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      tabline = {},
      extensions = { 'fugitive', 'neo-tree' },
    })
  end,
}
