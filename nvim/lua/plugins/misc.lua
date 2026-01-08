-- Standalone plugins with less than 10 lines of config go here
return {
  -- {
  --   -- File icons
  --   'nvim-tree/nvim-web-devicons',
  --   lazy = false,
  --   config = function()
  --     require('nvim-web-devicons').setup({
  --       default = true,
  --       strict = true,
  --       override = {
  --         sh = { icon = '', color = '#89e051', name = 'Sh' },
  --         bash = { icon = '', color = '#89e051', name = 'Bash' },
  --         zsh = { icon = '', color = '#89e051', name = 'Zsh' },
  --       },
  --       override_by_filename = {
  --         ['setup.sh'] = { icon = '', color = '#89e051', name = 'SetupSh' },
  --         ['.zshrc'] = { icon = '', color = '#89e051', name = 'Zshrc' },
  --         ['.zshenv'] = { icon = '', color = '#89e051', name = 'Zshenv' },
  --       },
  --       override_by_extension = {
  --         ['sh'] = { icon = '', color = '#89e051', name = 'Sh' },
  --       },
  --     })
  --   end,
  -- },
  {
    -- Tmux & split window navigation
    'christoomey/vim-tmux-navigator',
  },
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },
  {
    -- Powerful Git integration for Vim
    'tpope/vim-fugitive',
  },
  {
    -- GitHub integration for vim-fugitive
    'tpope/vim-rhubarb',
  },
  {
    -- Hints keybinds
    'folke/which-key.nvim',
  },
  {
    -- Autoclose parentheses, brackets, quotes, etc.
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup({})
    end,
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('todo-comments').setup({ signs = false })
    end,
  },
  {
    -- High-performance color highlighter
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    -- Git blame plugin (shows in lualine only)
    'f-person/git-blame.nvim',
    event = 'VeryLazy',
    config = function()
      vim.g.gitblame_display_virtual_text = 0 -- Disable inline, show in lualine only
      vim.g.gitblame_message_template = '<author> at <date> • <summary>'
      vim.g.gitblame_date_format = '%d %b %Y'  -- Jul 7 2026
      vim.g.gitblame_message_when_not_committed = 'Not committed yet'
    end,
  },
}
