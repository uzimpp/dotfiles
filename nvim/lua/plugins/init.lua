-- Load all custom plugins (without LazyVim defaults)
return {
  -- Theme
  require 'plugins.themes.anysphere',
  
  -- Core functionality
  require 'plugins.lsp',
  require 'plugins.autocompletion',
  require 'plugins.treesitter',
  
  -- UI components
  require 'plugins.ui',
  require 'plugins.alpha',
  require 'plugins.bufferline',
  require 'plugins.lualine',
  
  -- File management
  require 'plugins.neo-tree',
  require 'plugins.telescope',
  require 'plugins.oil',
  
  -- Utilities
  require 'plugins.comment',
  require 'plugins.gitsigns',
  require 'plugins.indent-blankline',
  require 'plugins.misc',
  require 'plugins.trouble',
  require 'plugins.session',
  require 'plugins.harpoon',
  require 'plugins.dap',
  require 'plugins.lazygit',
}
