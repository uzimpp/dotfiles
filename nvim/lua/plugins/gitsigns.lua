-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
  'lewis6991/gitsigns.nvim',
  event = 'VeryLazy',
  config = function()
    require('gitsigns').setup({
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '▎' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '▎' },
      },
      -- Line blame feeds lualine via vim.b.gitsigns_blame_line; virt_text off.
      current_line_blame = true,
      current_line_blame_opts = { virt_text = false, delay = 0 },
      current_line_blame_formatter = '  <author> at <author_time:%d %b %Y>',
      current_line_blame_formatter_nc = '  Not committed yet',
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation between hunks
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = 'Next git hunk' })

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = 'Prev git hunk' })

        -- Actions
        map('n', '<leader>gs', gs.stage_hunk, { desc = 'Stage hunk' })
        map('n', '<leader>gr', gs.reset_hunk, { desc = 'Reset hunk' })
        map('v', '<leader>gs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
          { desc = 'Stage hunk' })
        map('v', '<leader>gr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
          { desc = 'Reset hunk' })
        map('n', '<leader>gS', gs.stage_buffer, { desc = 'Stage buffer' })
        map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
        map('n', '<leader>gR', gs.reset_buffer, { desc = 'Reset buffer' })
        map('n', '<leader>gp', gs.preview_hunk, { desc = 'Preview hunk' })
        map('n', '<leader>gd', gs.diffthis, { desc = 'Diff this' })
        map('n', '<leader>gD', function() gs.diffthis('~') end, { desc = 'Diff this ~' })
        map('n', '<leader>gt', gs.toggle_deleted, { desc = 'Toggle deleted' })
      end,
    })
  end,
}
