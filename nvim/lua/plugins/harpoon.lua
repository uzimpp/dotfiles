-- Harpoon: Quick file navigation (marked files)
-- Using <leader>m prefix for "marked" files
return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require('harpoon')
    harpoon:setup()

    -- Harpoon menu and add
    vim.keymap.set('n', '<leader>m', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Harpoon: Toggle menu' })

    vim.keymap.set('n', '<leader>M', function()
      harpoon:list():append()
    end, { desc = 'Harpoon: Mark file' })

    -- Quick access to marked files (m + number)
    vim.keymap.set('n', '<leader>m1', function()
      harpoon:list():select(1)
    end, { desc = 'Harpoon: Go to mark 1' })
    vim.keymap.set('n', '<leader>m2', function()
      harpoon:list():select(2)
    end, { desc = 'Harpoon: Go to mark 2' })
    vim.keymap.set('n', '<leader>m3', function()
      harpoon:list():select(3)
    end, { desc = 'Harpoon: Go to mark 3' })
    vim.keymap.set('n', '<leader>m4', function()
      harpoon:list():select(4)
    end, { desc = 'Harpoon: Go to mark 4' })
    vim.keymap.set('n', '<leader>m5', function()
      harpoon:list():select(5)
    end, { desc = 'Harpoon: Go to mark 5' })

    -- Navigate between marked files
    vim.keymap.set('n', '<leader>mp', function()
      harpoon:list():prev()
    end, { desc = 'Harpoon: Previous mark' })
    vim.keymap.set('n', '<leader>mn', function()
      harpoon:list():next()
    end, { desc = 'Harpoon: Next mark' })
  end,
}
