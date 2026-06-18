-- Harpoon: Quick file navigation with pinned slots
-- <leader>1-9      → jump to harpoon slot
-- <leader>ha       → append current file to list
-- <leader>h1-9     → pin current file to specific slot
-- <leader>hh       → toggle harpoon menu
-- <leader>hp/hn    → cycle prev/next
return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require('harpoon')
    harpoon:setup()

    -- Toggle harpoon menu
    vim.keymap.set('n', '<leader>hh', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Harpoon: Toggle menu' })

    -- Append current file to end of harpoon list
    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():append()
    end, { desc = 'Harpoon: Add file' })

    -- Pin current file to a specific slot (overwrites existing entry)
    local function harpoon_pin(n)
      local list = harpoon:list()
      local item = list.config.create_list_item(list.config)
      for i = #list.items + 1, n do
        list.items[i] = nil
      end
      list.items[n] = item
      list:send_update()
    end

    -- Navigate to harpoon slot (leader + number)
    for i = 1, 9 do
      vim.keymap.set('n', '<leader>' .. i, function()
        harpoon:list():select(i)
      end, { desc = 'Harpoon: Go to slot ' .. i })
    end

    -- Pin current file to slot (leader + h + number)
    for i = 1, 9 do
      vim.keymap.set('n', '<leader>h' .. i, function()
        harpoon_pin(i)
      end, { desc = 'Harpoon: Pin to slot ' .. i })
    end

    -- Cycle through harpoon files
    vim.keymap.set('n', '<leader>hp', function()
      harpoon:list():prev()
    end, { desc = 'Harpoon: Previous file' })
    vim.keymap.set('n', '<leader>hn', function()
      harpoon:list():next()
    end, { desc = 'Harpoon: Next file' })
  end,
}
