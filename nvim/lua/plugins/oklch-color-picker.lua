-- Inline color preview + graphical color picker (Neovim 0.10+).
-- Replaces nvim-colorizer: hex/rgb/hsl/oklch + Tailwind (e.g. bg-red-800), LSP document colors.
return {
    'eero-lehtinen/oklch-color-picker.nvim',
    event = 'VeryLazy',
    version = '*',
    keys = {
        { '<leader>v', function() require('oklch-color-picker').pick_under_cursor() end, desc = 'Color pick under cursor' },
        { '<leader>V', function() require('oklch-color-picker').open_picker() end,       desc = 'Open color picker' },
    },
    opts = {
        highlight = {
            enabled = true,
            style = 'background', -- "little box" swatch on the color text
            enabled_lsps = true,
        },
    },
}
