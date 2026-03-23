return {
  "mrjones2014/smart-splits.nvim",
  config = function()
    local ss = require("smart-splits")

    ss.setup({
      -- auto-detects WezTerm or Ghostty, no need to hardcode
      multiplexer_integration = nil,
    })

    vim.keymap.set("n", "<C-h>", ss.move_cursor_left)
    vim.keymap.set("n", "<C-j>", ss.move_cursor_down)
    vim.keymap.set("n", "<C-k>", ss.move_cursor_up)
    vim.keymap.set("n", "<C-l>", ss.move_cursor_right)
  end
}
