-- Standalone plugins with less than 10 lines of config go here
return {
  {
    -- File icons
    'nvim-tree/nvim-web-devicons',
    lazy = false,
    config = function()
      require('nvim-web-devicons').setup({
        default = true,
        strict = true,
        -- override = {
        --   sh = { icon = '', color = '#89e051', name = 'Sh' },
        --   bash = { icon = '', color = '#89e051', name = 'Bash' },
        --   zsh = { icon = '', color = '#89e051', name = 'Zsh' },
        -- },
        -- override_by_filename = {
        --   ['setup.sh'] = { icon = '', color = '#89e051', name = 'SetupSh' },
        --   ['.zshrc'] = { icon = '', color = '#89e051', name = 'Zshrc' },
        --   ['.zshenv'] = { icon = '', color = '#89e051', name = 'Zshenv' },
        -- },
        -- override_by_extension = {
        --   ['sh'] = { icon = '', color = '#89e051', name = 'Sh' },
        -- },
      })
    end,
  },
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
    -- Surround text with brackets, quotes, tags, etc.
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup({})
    end,
    -- Usage: ys{motion}{char} to add, ds{char} to delete, cs{old}{new} to change
    -- Examples: ysiw" (surround word with "), ds' (delete surrounding '), cs"' (change " to ')
  },
  {
    -- Flash: quick jump to any location
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end,       desc = 'Flash' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
    },
  },
  {
    -- Better search and replace across files
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
    keys = {
      { '<leader>sr', function() require('spectre').toggle() end,                            desc = 'Search and Replace' },
      { '<leader>sW', function() require('spectre').open_visual({ select_word = true }) end, desc = 'Search current word' },
    },
  },
}
