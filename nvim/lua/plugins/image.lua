return {
  '3rd/image.nvim',
  lazy = false,
  opts = {
    backend = 'kitty',
    kitty_method = 'normal',
    integrations = {
      markdown = { enabled = false },
      neorg = { enabled = false },
      syslang = { enabled = false },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = 100,
    max_height_window_percentage = 100,
    window_overlap_clear_enabled = true,
    editor_only_render_when_focused = true,
    tmux_show_only_in_active_window = true,
  },
  config = function(_, opts)
    local home = vim.fn.expand('~')
    package.path = package.path .. ';' .. home .. '/.luarocks/share/lua/5.1/?/init.lua'
    package.path = package.path .. ';' .. home .. '/.luarocks/share/lua/5.1/?.lua'
    require('image').setup(opts)

    local augroup = vim.api.nvim_create_augroup('ImageViewer', { clear = true })
    vim.api.nvim_create_autocmd('BufReadCmd', {
      group = augroup,
      pattern = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.bmp', '*.tiff', '*.tif' },
      callback = function(ev)
        local win = vim.api.nvim_get_current_win()
        vim.wo[win].number = false
        vim.wo[win].relativenumber = false
        vim.wo[win].signcolumn = 'no'
        vim.bo[ev.buf].buftype = 'nofile'
        vim.bo[ev.buf].modifiable = false

        local width = vim.api.nvim_win_get_width(win)
        local height = vim.api.nvim_win_get_height(win)
        local image = require('image').from_file(ev.file, {
          window = win,
          buffer = ev.buf,
          width = width,
          height = height,
          with_virtual_padding = false,
        })
        if image then
          image:render()
        end
      end,
    })
  end,
}
