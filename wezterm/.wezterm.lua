local wezterm = require("wezterm")
-- Add home directory to Lua package path so we can require config.lua and events.lua
local home = os.getenv("HOME")
package.path = package.path .. ";" .. home .. "/?.lua"

local config = require("config")
require("events")

-- VSCode Anysphere colors (matches nvim/lua/plugins/themes/anysphere.lua)
local anysphere_colors = {
	foreground = "#D8DEE9",  -- editor_fg
	background = "#141414",  -- editor_bg
	cursor_bg = "#D8DEE9",
	cursor_fg = "#1a1a1a",
	cursor_border = "#D8DEE9",
	selection_fg = "#D8DEE9",
	selection_bg = "#3a3a3a",  -- selection (blended)
	ansi = {
		"#2A2A2A", -- black (gray1)
		"#BF616A", -- red (red1)
		"#A3BE8C", -- green (green1)
		"#EBCB8B", -- yellow (yellow1)
		"#81A1C1", -- blue (blue1)
		"#B48EAD", -- magenta (purple1)
		"#88C0D0", -- cyan (blue2)
		"#CCCCCC", -- white (ui_fg)
	},
	brights = {
		"#505050", -- bright black (gray3)
		"#BF616A", -- bright red
		"#a8cc7c", -- bright green (green2)
		"#EBCB8B", -- bright yellow
		"#87c3ff", -- bright blue (blue3)
		"#e394dc", -- bright magenta (pink)
		"#88C0D0", -- bright cyan
		"#E5E5E5", -- bright white (sidebar_fg)
	},
	tab_bar = {
		background = "#141414",  -- ui_bg
		active_tab = { bg_color = "#2A2A2A", fg_color = "#D8DEE9" },
		inactive_tab = { bg_color = "#141414", fg_color = "#999999" },
		new_tab = { bg_color = "#141414", fg_color = "#505050" },
	},
}

-- OneDark colors (based on kitty/onedark.conf)
local onedark_colors = {
	foreground = "#abb2bf",
	background = "#282c34",
	cursor_bg = "#abb2bf",
	cursor_fg = "#282c34",
	cursor_border = "#abb2bf",
	selection_fg = "#abb2bf",
	selection_bg = "#3e4451",
	ansi = {
		"#282c34", -- black
		"#e06c75", -- red
		"#98c379", -- green
		"#e5c07b", -- yellow
		"#61afef", -- blue
		"#be5046", -- magenta
		"#56b6c2", -- cyan
		"#979eab", -- white
	},
	brights = {
		"#393e48", -- bright black
		"#d19a66", -- bright red
		"#56b6c2", -- bright green
		"#e5c07b", -- bright yellow
		"#61afef", -- bright blue
		"#be5046", -- bright magenta
		"#56b6c2", -- bright cyan
		"#abb2bf", -- bright white
	},
	tab_bar = {
		background = "#282c34",
		active_tab = { bg_color = "#979eab", fg_color = "#282c34" },
		inactive_tab = { bg_color = "#282c34", fg_color = "#abb2bf" },
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
	
	return theme or "catppuccin"
end

local theme = get_theme()
-- Debug: log the theme being used
wezterm.log_info("WezTerm theme detected: " .. (theme or "nil"))

-- Apply theme
if theme == "anysphere" then
	-- Use custom anysphere colors
	config.colors = anysphere_colors
	wezterm.log_info("Applied anysphere custom colors")
elseif theme == "catppuccin" then
	config.color_scheme = "Catppuccin Mocha"
	wezterm.log_info("Applied Catppuccin Mocha")
elseif theme == "onedark" then
	-- Use custom onedark colors (built-in scheme may not exist)
	config.colors = onedark_colors
	wezterm.log_info("Applied OneDark custom colors")

else
	-- Default to anysphere
	config.colors = anysphere_colors
	wezterm.log_info("Applied default: anysphere")
end

return config
