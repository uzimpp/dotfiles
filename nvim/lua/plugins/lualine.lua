return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
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
      return vim.fn.winwidth(0) > 100
    end

    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      sections = { 'error', 'warn' },
      symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      colored = true,
      update_in_insert = true,
      always_visible = false,
      cond = hide_in_width,
    }

    local diff = {
      'diff',
      colored = true,
      symbols = { added = '+', modified = '~', removed = '-' },
      cond = hide_in_width,
    }

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

    -- Custom anysphere lualine theme
    -- Colors from wezterm anysphere config
    local colors = {
      bg = '#181818',
      bg_alt = '#26292f',
      fg = '#d6d6dd',
      fg_dim = '#9ca3b2',
      blue = '#61afef',
      green = '#98c379',
      magenta = '#e394dc',
      red = '#f75f5f',
      yellow = '#ebc88d',
      cyan = '#83d6c5',
    }

    local anysphere_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.bg_alt, fg = colors.blue },      -- mode color text
        c = { bg = colors.bg, fg = colors.fg_dim },        -- muted text
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.bg_alt, fg = colors.green },     -- mode color text
        c = { bg = colors.bg, fg = colors.fg_dim },        -- muted text
      },
      visual = {
        a = { bg = colors.magenta, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.bg_alt, fg = colors.magenta },   -- mode color text
        c = { bg = colors.bg, fg = colors.fg_dim },        -- muted text
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.bg_alt, fg = colors.red },       -- mode color text
        c = { bg = colors.bg, fg = colors.fg_dim },        -- muted text
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.bg_alt, fg = colors.yellow },    -- mode color text
        c = { bg = colors.bg, fg = colors.fg_dim },        -- muted text
      },
      inactive = {
        a = { bg = colors.bg, fg = colors.fg_dim },
        b = { bg = colors.bg, fg = colors.fg_dim },
        c = { bg = colors.bg, fg = colors.fg_dim },
      },
    }

    -- Get lualine theme
    local function get_lualine_theme()
      local theme = vim.g.theme or os.getenv('THEME') or 'anysphere'
      if theme == 'anysphere' then
        return anysphere_theme
      end
      local lualine_theme_map = {
        nordic = 'nordic',
        nord = 'nord',
        onedark = 'onedark',
        catppuccin = 'catppuccin',
      }
      return lualine_theme_map[theme] or anysphere_theme
    end

    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = get_lualine_theme(),
        -- https://www.nerdfonts.com/cheat-sheet
        --             ▓▒░ ░▒▓
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { 'alpha' },
        globalstatus = true,
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { 'branch', diff, diagnostics },
        lualine_c = { filename },
        lualine_x = { git_blame , { 'filetype', cond = hide_in_width } },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = { mode },
        lualine_b = { { 'filename', path = 1 } },
        lualine_c = { },
        lualine_x = { { 'filetype', icon_only = false } },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      tabline = {},
      extensions = { 'fugitive', 'neo-tree' },
    })
  end,
}
