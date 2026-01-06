local wezterm = require("wezterm")
local config = require("config")
require("events")

-- Actual Anysphere colors from the plugin (anysphere.nvim)
local anysphere_colors = {
	foreground = "#d6d6dd",
	background = "#181818",
	cursor_bg = "#61afef",
	cursor_fg = "#181818",
	cursor_border = "#61afef",
	selection_fg = "#d6d6dd",
	selection_bg = "#163761",
	ansi = {
		"#4b5261", -- black (darkgray)
		"#f75f5f", -- red
		"#98c379", -- green
		"#ebc88d", -- yellow
		"#61afef", -- blue (aqua)
		"#e394dc", -- magenta
		"#83d6c5", -- cyan
		"#b3b3b3", -- white (gray)
	},
	brights = {
		"#5b5b5b", -- bright black (gray2)
		"#f75f5f", -- bright red
		"#98c379", -- bright green
		"#ebc88d", -- bright yellow
		"#94c1fa", -- bright blue (softblue)
		"#e394dc", -- bright magenta
		"#83d6c5", -- bright cyan
		"#eeeeee", -- bright white
	},
	tab_bar = {
		background = "#181818",
		active_tab = { bg_color = "#26292f", fg_color = "#d6d6dd" },
		inactive_tab = { bg_color = "#181818", fg_color = "#9ca3b2" },
	},
}

-- Get theme from .zshenv file
local function get_theme()
	-- Try environment variable first (set when launched from shell)
	local theme = os.getenv("THEME") or os.getenv("WEZTERM_THEME")
	
	-- If not in env, read from .zshenv file
	if not theme or theme == "" then
		local zshenv_path = os.getenv("HOME") .. "/.config/zsh/.zshenv"
		local file = io.open(zshenv_path, "r")
		if file then
			for line in file:lines() do
				-- Match: export THEME="value"
				local match = line:match('export%s+THEME%s*=%s*"([^"]+)"')
				if match then
					theme = match
					break
				end
			end
			file:close()
		end
	end
	
	return theme or "catpuccin"
end

local theme = get_theme()
-- Debug: log the theme being used
wezterm.log_info("WezTerm theme detected: " .. (theme or "nil"))

-- Apply theme
if theme == "anysphere" then
	-- Use custom anysphere colors
	config.colors = anysphere_colors
	wezterm.log_info("Applied anysphere custom colors")
elseif theme == "catpuccin" then
	config.color_scheme = "Catppuccin Mocha"
	wezterm.log_info("Applied Catppuccin Mocha")
elseif theme == "onedark" then
	config.color_scheme = "OneDark"
	wezterm.log_info("Applied OneDark")
elseif theme == "nord" or theme == "nordic" then
	config.color_scheme = "Nord"
	wezterm.log_info("Applied Nord")
else
	config.color_scheme = "Catppuccin Mocha"
	wezterm.log_info("Applied default: Catppuccin Mocha")
end

return config
