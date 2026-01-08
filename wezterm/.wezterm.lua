local wezterm = require("wezterm")

-- Add home directory to Lua package path so we can require config.lua and events.lua
local home = os.getenv("HOME")
package.path = package.path .. ";" .. home .. "/?.lua"

local config = require("config")
require("events")

-- Actual Anysphere colors from the plugin (anysphere.nvim)
-- Matches kitty/anysphere.conf for consistency
local anysphere_colors = {
	foreground = "#d6d6dd",
	background = "#181818",
	cursor_bg = "#eeeeee", -- matches kitty config
	cursor_fg = "#181818",
	cursor_border = "#eeeeee",
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

-- Nord colors (standard Nord palette)
local nord_colors = {
	foreground = "#D8DEE9",
	background = "#2E3440",
	cursor_bg = "#D8DEE9",
	cursor_fg = "#2E3440",
	cursor_border = "#D8DEE9",
	selection_fg = "#D8DEE9",
	selection_bg = "#434C5E",
	ansi = {
		"#3B4252", -- black
		"#BF616A", -- red
		"#A3BE8C", -- green
		"#EBCB8B", -- yellow
		"#5E81AC", -- blue
		"#B48EAD", -- magenta
		"#88C0D0", -- cyan
		"#E5E9F0", -- white
	},
	brights = {
		"#4C566A", -- bright black
		"#BF616A", -- bright red
		"#A3BE8C", -- bright green
		"#EBCB8B", -- bright yellow
		"#81A1C1", -- bright blue
		"#B48EAD", -- bright magenta
		"#8FBCBB", -- bright cyan
		"#ECEFF4", -- bright white
	},
	tab_bar = {
		background = "#2E3440",
		active_tab = { bg_color = "#5E81AC", fg_color = "#2E3440" },
		inactive_tab = { bg_color = "#3B4252", fg_color = "#D8DEE9" },
	},
}

-- Nordic colors (warmer and darker than Nord, with more Aurora prominence)
-- Based on AlexvZyl/nordic.nvim palette and kitty/nordic.conf
local nordic_colors = {
	foreground = "#D8DEE9",
	background = "#2E3440", -- darker base than standard Nord
	cursor_bg = "#88C0D0",
	cursor_fg = "#2E3440",
	cursor_border = "#88C0D0",
	selection_fg = "#D8DEE9",
	selection_bg = "#434C5E",
	ansi = {
		"#3B4252", -- black
		"#BF616A", -- red
		"#A3BE8C", -- green
		"#EBCB8B", -- yellow
		"#5E81AC", -- blue
		"#B48EAD", -- magenta
		"#8FBCBB", -- cyan (Aurora - more prominent in Nordic)
		"#ECEFF4", -- white
	},
	brights = {
		"#4C566A", -- bright black
		"#BF616A", -- bright red
		"#A3BE8C", -- bright green
		"#EBCB8B", -- bright yellow
		"#81A1C1", -- bright blue
		"#B48EAD", -- bright magenta
		"#8FBCBB", -- bright cyan (Aurora)
		"#ECEFF4", -- bright white
	},
	tab_bar = {
		background = "#2E3440",
		active_tab = { bg_color = "#5E81AC", fg_color = "#2E3440" },
		inactive_tab = { bg_color = "#3B4252", fg_color = "#D8DEE9" },
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
elseif theme == "nordic" then
	config.colors = nordic_colors
	wezterm.log_info("Applied Nordic custom colors")
elseif theme == "nord" then
	-- Use custom nord colors (built-in scheme may not exist)
	config.colors = nord_colors
	wezterm.log_info("Applied Nord custom colors")
else
	-- Default to anysphere
	config.colors = anysphere_colors
	wezterm.log_info("Applied default: anysphere")
end

return config
