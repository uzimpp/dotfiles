-- Trouble.nvim: Diagnostics and quickfix UI
return {
  'folke/trouble.nvim',
  cmd = { 'TroubleToggle', 'Trouble' },
  config = function()
    require('trouble').setup({
      -- Your configuration here
      auto_open = false, -- automatically open the list when you have diagnostics
      auto_close = false, -- automatically close the list when you have no diagnostics
      auto_preview = true, -- automatically preview the location of the diagnostic
      auto_fold = false, -- automatically fold a file trouble list at creation
      auto_jump = { 'lsp_definitions' }, -- for the given modes, automatically jump if there is only a single result
      signs = {
        -- icons / text used for a diagnostic
        error = '󰅚',
        warning = '󰀪',
        hint = '󰌶',
        information = '󰋼',
        other = '󰗡',
      },
      use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
    })
    
    -- Keymaps
    vim.keymap.set('n', '<leader>xx', '<cmd>TroubleToggle document_diagnostics<cr>', { desc = 'Document Diagnostics (Trouble)' })
    vim.keymap.set('n', '<leader>xX', '<cmd>TroubleToggle workspace_diagnostics<cr>', { desc = 'Workspace Diagnostics (Trouble)' })
    vim.keymap.set('n', '<leader>xL', '<cmd>TroubleToggle loclist<cr>', { desc = 'Location List (Trouble)' })
    vim.keymap.set('n', '<leader>xQ', '<cmd>TroubleToggle quickfix<cr>', { desc = 'Quickfix List (Trouble)' })
  end,
}

