require 'core.options' -- Load general options
require 'core.keymaps' -- Load general keymaps
require 'core.snippets' -- Custom code snippets

-- LazyVim Bootstrap with Theme System
-- This file bootstraps LazyVim and sets up the theme system

-- Get theme from environment variable or .zshenv file
local function get_theme()
  -- Try environment variable first
  local env_theme = os.getenv('NVIM_THEME') or os.getenv('THEME')
  if env_theme and env_theme ~= '' then
    return env_theme
  end
  
  -- Fallback: read from .zshenv file
  local zshenv_path = os.getenv('HOME') .. '/.config/zsh/.zshenv'
  local file = io.open(zshenv_path, 'r')
  if file then
    for line in file:lines() do
      local match = line:match('export%s+THEME%s*=%s*"([^"]+)"')
      if match then
        file:close()
        return match
      end
    end
    file:close()
  end
  
  -- Default fallback
  return 'catpuccin'
end

-- Store theme for later use
local current_theme = get_theme()
vim.g.theme = current_theme

-- Bootstrap LazyVim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Theme to colorscheme mapping
local function get_colorscheme(theme)
  local theme_map = {
    nordic = 'nord',
    nord = 'nord',
    onedark = 'onedark',
    catpuccin = 'catppuccin',
    anysphere = 'cursor-dark-anysphere',
  }
  return theme_map[theme] or 'catppuccin'
end

-- Load LazyVim configuration
require('lazy').setup({
  -- LazyVim core
  { 'LazyVim/LazyVim', import = 'lazyvim.plugins' },
  
  -- Theme system - load all themes but only activate the selected one
  { import = 'plugins.themes.nordic' },
  { import = 'plugins.themes.nord' },
  { import = 'plugins.themes.onedark' },
  { import = 'plugins.themes.catpuccin' },
  { import = 'plugins.themes.anysphere' },
  
  -- Additional plugins can be added here
  { import = 'plugins' },
}, {
  defaults = {
    lazy = true,
    version = false,
  },
  install = { colorscheme = { get_colorscheme(current_theme) } },
  checker = { enabled = true },
  -- performance = {
  --   rtp = {
  --     disabled_plugins = {
  --       'gzip',
  --       'matchit',
  --       'matchparen',
  --       'netrwPlugin',
  --       'tarPlugin',
  --       'tohtml',
  --       'tutor',
  --       'zipPlugin',
  --     },
  --   },
  -- },
})

local function apply_theme()
  local theme = get_theme()
  local colorscheme = get_colorscheme(theme)
  
  vim.defer_fn(function()
    if colorscheme == 'nord' then
      local ok, nord = pcall(require, 'nord')
      if ok then
        nord.set()
      else
        pcall(vim.cmd.colorscheme, colorscheme)
      end
    elseif colorscheme == 'onedark' then
      local ok, onedark = pcall(require, 'onedark')
      if ok then
        onedark.load()
      else
        pcall(vim.cmd.colorscheme, colorscheme)
      end
    elseif colorscheme == 'catppuccin' then
      local ok, catppuccin = pcall(require, 'catppuccin')
      if ok then
        catppuccin.load()
      else
        pcall(vim.cmd.colorscheme, colorscheme)
      end
    elseif colorscheme == 'cursor-dark-anysphere' then
      pcall(vim.cmd.colorscheme, 'cursor-dark-anysphere')
    else
      pcall(vim.cmd.colorscheme, colorscheme)
    end
  end, 100)
end

-- Apply theme after LazyVim starts
vim.api.nvim_create_autocmd('User', {
  pattern = 'LazyVimStarted',
  callback = apply_theme,
  once = true,
})

-- Also try to apply theme on VimEnter (fallback)
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.schedule(apply_theme)
  end,
  once = true,
})

-- Manual command to reload theme
vim.api.nvim_create_user_command('ReloadTheme', function()
  apply_theme()
end, { desc = 'Reload theme from .zshenv' })

-- Also apply theme when LazyVim plugins are loaded
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    vim.schedule(apply_theme)
  end,
  once = true,
})

