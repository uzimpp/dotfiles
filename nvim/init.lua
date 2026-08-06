require 'core.options'  -- Load general options
require 'core.keymaps'  -- Load general keymaps
require 'core.snippets' -- Custom code snippets

-- Suppress LSP loading messages globally
local _notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == 'string' and (msg:lower():find('load') or msg:lower():find('workspace')) then return end
  if level == vim.log.levels.DEBUG then return end
  return _notify(msg, level, opts)
end

-- Load theme configuration
local theme = require 'config.theme'
local current_theme = theme.get_theme()
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

-- Setup plugins
require('lazy').setup({
  { "vague-theme/vague.nvim", lazy = false, priority = 1000 },
  require(theme.get_theme_module()),
  require 'plugins.telescope',
  require 'plugins.treesitter',
  require 'plugins.lsp',
  require 'plugins.autocompletion',
  require 'plugins.ui',
  require 'plugins.startify',
  require 'plugins.lualine',
  require 'plugins.formatting',
  require 'plugins.neo-tree',
  require 'plugins.indent-blankline',
  require 'plugins.smear-cursor',
  require 'plugins.markdown-preview',
  require 'plugins.lazygit',
  require 'plugins.comment',
  require 'plugins.gitsigns',
  require 'plugins.autopairs',
  require 'plugins.surround',
  require 'plugins.harpoon',
  require 'plugins.dap',
  require 'plugins.trouble',
  require 'plugins.which-key',
  require 'plugins.image',
}, {
  defaults = {
    lazy = true,
    version = false,
  },
  checker = { enabled = false },
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
