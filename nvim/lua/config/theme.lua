-- Theme configuration for LazyVim
-- This module handles theme switching based on environment variables

local M = {}

-- Get current theme from environment
function M.get_theme()
  local env_theme = os.getenv('NVIM_THEME') or os.getenv('THEME')
  return env_theme or 'anysphere'
end

-- Theme to colorscheme mapping
function M.get_colorscheme(theme)
  local theme_map = {
    nordic = 'nord',
    nord = 'nord',
    onedark = 'onedark',
    catppuccin = 'catppuccin',
    anysphere = 'cursor-dark-anysphere',
  }
  return theme_map[theme] or 'cursor-dark-anysphere'
end

-- Apply theme
function M.apply_theme(theme)
  theme = theme or M.get_theme()
  local colorscheme = M.get_colorscheme(theme)
  vim.cmd('colorscheme ' .. colorscheme)
end

return M

