-- Session Management: Save and restore Neovim sessions
return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  config = function()
    require('persistence').setup({
      options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp' },
    })

    -- Close Neo-tree before saving session to avoid restoring broken buffers
    vim.api.nvim_create_autocmd('User', {
      pattern = 'PersistenceSavePre',
      callback = function()
        vim.cmd('silent! Neotree close')
      end,
    })

    -- Close Neo-tree after loading session to cleanup any bad buffers from old sessions
    vim.api.nvim_create_autocmd('User', {
      pattern = 'PersistenceLoadPost',
      callback = function()
        vim.cmd('silent! Neotree close')
      end,
    })

    -- Keymaps
    vim.keymap.set('n', '<leader>qs', function()
      require('persistence').load()
    end, { desc = 'Restore Session' })

    vim.keymap.set('n', '<leader>ql', function()
      require('persistence').load({ last = true })
    end, { desc = 'Restore Last Session' })

    vim.keymap.set('n', '<leader>qd', function()
      require('persistence').stop()
    end, { desc = 'Don\'t Save Current Session' })
  end,
}
