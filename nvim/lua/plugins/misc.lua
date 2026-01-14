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
      vim.g.gitblame_max_commit_summary_length = 20 -- Truncate long commit messages
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
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
    },
  },
  {
    -- Better search and replace across files
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
    keys = {
      { '<leader>sr', function() require('spectre').toggle() end, desc = 'Search and Replace' },
      { '<leader>sW', function() require('spectre').open_visual({ select_word = true }) end, desc = 'Search current word' },
    },
  },
  {
    -- Undo tree visualization
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = {
      { '<leader>u', '<cmd>UndotreeToggle<CR>', desc = 'Toggle Undo Tree' },
    },
  },
  {
    -- Toggle terminal
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = {
      { '<C-\\>', '<cmd>ToggleTerm<CR>', desc = 'Toggle Terminal' },
      { '<leader>tt', '<cmd>ToggleTerm direction=float<CR>', desc = 'Float Terminal' },
      { '<leader>th', '<cmd>ToggleTerm direction=horizontal size=15<CR>', desc = 'Horizontal Terminal' },
      { '<leader>tv', '<cmd>ToggleTerm direction=vertical size=80<CR>', desc = 'Vertical Terminal' },
    },
    opts = {
      shell = vim.o.shell,
      float_opts = { border = 'rounded' },
    },
  },
  {
    -- Zen mode for focused writing
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    keys = {
      { '<leader>z', '<cmd>ZenMode<CR>', desc = 'Zen Mode' },
    },
    opts = {
      window = { width = 100 },
    },
  },
  {
    -- Auto close HTML/JSX tags
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    opts = {},
  },
  {
    -- Markdown preview
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview' },
    ft = { 'markdown' },
    build = function() vim.fn['mkdp#util#install']() end,
    keys = {
      { '<leader>mp', '<cmd>MarkdownPreviewToggle<CR>', desc = 'Markdown Preview' },
    },
  },
}
