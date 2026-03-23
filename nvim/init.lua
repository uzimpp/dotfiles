require 'core.options'  -- Load general options
require 'core.keymaps'  -- Load general keymaps
require 'core.snippets' -- Custom code snippets

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
  require(theme.get_theme_module()),
  require 'plugins.telescope',
  require 'plugins.treesitter',
  require 'plugins.lsp',
  require 'plugins.autocompletion',
  require 'plugins.ui',
  require 'plugins.alpha',
  require 'plugins.lualine',
  require 'plugins.gitblame',
  require 'plugins.oklch-color-picker',
  -- require 'plugins.bufferline',
  -- require 'plugins.splits',
  require 'plugins.formatting',
  require 'plugins.rainbow',
  require 'plugins.neo-tree',
  require 'plugins.oil',
  require 'plugins.indent-blankline',
  require 'plugins.smear-cursor',
  require 'plugins.markdown-preview',
  require 'plugins.lazygit',
  require 'plugins.comment',
  require 'plugins.gitsigns',
  require 'plugins.autopairs',
  require 'plugins.surround',
  require 'plugins.flash',
  require 'plugins.spectre',
  require 'plugins.harpoon',
  require 'plugins.dap',
  require 'plugins.trouble',
  require 'plugins.session',
  require 'plugins.which-key',
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
