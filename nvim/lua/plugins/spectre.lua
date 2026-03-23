return {
  {
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
    keys = {
      { '<leader>sr', function() require('spectre').toggle() end,                            desc = 'Search and Replace' },
      { '<leader>sW', function() require('spectre').open_visual({ select_word = true }) end, desc = 'Search current word' },
    },
  },
}
