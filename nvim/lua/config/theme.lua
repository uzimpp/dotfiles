-- Theme configuration module
-- Centralized theme management for Neovim

local M = {}

-- Theme to plugin module mapping
M.theme_modules = {
  onedark = 'plugins.themes.onedark',
  catppuccin = 'plugins.themes.catppuccin',
  anysphere = 'plugins.themes.anysphere',
  tokyonight = 'plugins.themes.tokyonight',
  mellifluous = 'plugins.themes.mellifluous',
  kanagawa = 'plugins.themes.kanagawa',
  vague = 'plugins.themes.vague',
}

-- Theme to colorscheme command mapping
M.colorschemes = { -- Set this to: onedark, catppuccin, anysphere, tokyonight, mellifluous, kanagawa, or vague
  onedark = 'onedark',
  catppuccin = 'catppuccin',
  anysphere = 'cursor-dark-anysphere',
  tokyonight = 'tokyonight',
  mellifluous = 'mellifluous',
  kanagawa = 'kanagawa',
  vague = 'vague',
}

-- Default theme if none is set
M.default_theme = 'vague'

-- Get current theme from environment variable or .zshenv file
function M.get_theme()
  -- First try environment variables
  local env_theme = os.getenv('NVIM_THEME') or os.getenv('THEME')
  if env_theme and env_theme ~= '' then
    return env_theme
  end

  -- Fallback: read from .zshenv file (check multiple locations).
  -- vim.fn.expand('~') works across macOS/Linux/WSL/Windows even when $HOME is unset.
  local home = vim.fn.expand('~')
  local zshenv_paths = {
    home .. '/dotfiles/zsh/.zshenv',
    home .. '/.config/zsh/.zshenv',
    home .. '/.zshenv',
  }

  for _, path in ipairs(zshenv_paths) do
    local file = io.open(path, 'r')
    if file then
      for line in file:lines() do
        local match = line:match('export%s+THEME%s*=%s*"([^"]+)"')
          or line:match("export%s+THEME%s*=%s*'([^']+)'")
          or line:match('export%s+THEME%s*=%s*([^%s#]+)')
        if match then
          file:close()
          return match
        end
      end
      file:close()
    end
  end

  return M.default_theme
end

-- Get the plugin module path for a theme
function M.get_theme_module(theme)
  theme = theme or M.get_theme()
  return M.theme_modules[theme] or M.theme_modules[M.default_theme]
end

-- Get the colorscheme name for a theme
function M.get_colorscheme(theme)
  theme = theme or M.get_theme()
  return M.colorschemes[theme] or M.colorschemes[M.default_theme]
end

-- Apply colorscheme
function M.apply()
  local theme = M.get_theme()
  local colorscheme = M.get_colorscheme(theme)
  vim.cmd.colorscheme(colorscheme)
end

-- Check if theme is valid
function M.is_valid(theme)
  return M.theme_modules[theme] ~= nil
end

-- List available themes
function M.list()
  local themes = {}
  for name, _ in pairs(M.theme_modules) do
    table.insert(themes, name)
  end
  table.sort(themes)
  return themes
end

return M
