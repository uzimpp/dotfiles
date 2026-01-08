require 'core.options' -- Load general options
require 'core.keymaps' -- Load general keymaps
require 'core.snippets' -- Custom code snippets

-- Get theme from environment variable or .zshenv file
local function get_theme()
  local env_theme = os.getenv('NVIM_THEME') or os.getenv('THEME')
  if env_theme and env_theme ~= '' then
    return env_theme
  end
  
  -- Fallback: read from .zshenv file
  local zshenv_path = os.getenv('HOME') .. '/.config/zsh/.zshenv'
  local file = io.open(zshenv_path, 'r')
  if file then
    for line in file:lines() do
      local match = line:match('export%s+THEME%s*=%s*"([^"]+)"') or line:match('export%s+THEME%s*=%s*([^%s]+)')
      if match then
        file:close()
        return match
      end
    end
    file:close()
  end
  
  return 'anysphere'
end

-- Store theme for later use
local current_theme = get_theme()
vim.g.theme = current_theme

-- Install package manager
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

-- Define a table of theme modules
local themes = {
  nordic = 'plugins.themes.nordic',
  nord = 'plugins.themes.nord',
  onedark = 'plugins.themes.onedark',
  catppuccin = 'plugins.themes.catppuccin',
  anysphere = 'plugins.themes.anysphere',
}

-- Setup plugins
require('lazy').setup({
  require(themes[get_theme()]),
  require 'plugins.telescope',
  require 'plugins.treesitter',
  require 'plugins.lsp',
  require 'plugins.autocompletion',
  require 'plugins.ui',
  require 'plugins.lualine',
  require 'plugins.bufferline',
  require 'plugins.neo-tree',
  require 'plugins.oil',
  require 'plugins.alpha',
  require 'plugins.indent-blankline',
  require 'plugins.lazygit',
  require 'plugins.comment',
  require 'plugins.gitsigns',
  require 'plugins.misc',
  require 'plugins.harpoon',
  require 'plugins.dap',
  require 'plugins.trouble',
  require 'plugins.session',
}, {
  defaults = {
    lazy = true,
    version = false,
  },
  checker = { enabled = true },
  ui = {
    -- If you have a Nerd Font, set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
