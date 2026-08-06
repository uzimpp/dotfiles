-- Lualine theme for the mellifluous colorset.
--
-- Lualine's `theme = "auto"` resolves a statusline theme by searching the
-- runtimepath for `lua/lualine/themes/<colorscheme>.lua` (see lualine's
-- utils/loader.lua -> load_theme). Because the Neovim config dir is on the
-- runtimepath, placing this file here makes "auto" pick it up whenever the
-- active colorscheme is "mellifluous", and lualine re-resolves it on its own
-- ColorScheme autocmd. Colors are pulled live from mellifluous so the
-- statusline tracks colorset/transparency changes.

local function hex(col)
	return col and (col.hex or col) or nil
end

local ok, colors = pcall(function()
	return require("mellifluous.colors").get_colors()
end)

-- mellifluous not ready (shouldn't happen once it's the active colorscheme):
-- fall back to lualine's auto theme rather than erroring.
if not ok or not colors then
	return require("lualine.themes.auto")
end

-- Every value handed to lualine must be a hex string, so mellifluous color
-- objects are always passed through hex() (col.hex), never used raw.
local ui_bg = hex(colors.dark_bg)
-- local ui_bg = hex(colors.bg4)
local fg_bright = hex(colors.fg2)
local fg_dim = hex(colors.fg4)

-- Active modes share the same shape; only section a's fg (the accent) differs.
local function mode(accent)
	return {
		a = { bg = ui_bg, fg = accent },
		b = { bg = ui_bg, fg = fg_bright },
		c = { bg = ui_bg, fg = fg_dim },
		x = { bg = ui_bg, fg = fg_dim },
		y = { bg = ui_bg, fg = fg_dim },
		z = { bg = ui_bg, fg = fg_dim },
	}
end

local inactive = { bg = ui_bg, fg = fg_dim }

return {
	normal = mode(hex(colors.red)),
	insert = mode(hex(colors.green)),
	visual = mode(hex(colors.purple)),
	replace = mode(hex(colors.yellow)),
	command = mode(hex(colors.orange)),
	inactive = {
		a = inactive,
		b = inactive,
		c = inactive,
		x = inactive,
		y = inactive,
		z = inactive,
	},
}
