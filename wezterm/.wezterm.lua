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

-- OneDark colors
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

-- Mellifluous colors — exact values computed from colorsets/mellifluous.lua (neutral=true)
local mellifluous_colors = {
	foreground    = "#dadada",  -- @text, @variable, etc from config
	background    = "#1a1a1a",  -- Normal bg from config
	cursor_bg     = "#cbaa88",  -- Cursor bg from config
	cursor_fg     = "#1a1a1a",  -- Cursor fg from config
	cursor_border = "#cbaa88",
	selection_fg  = "#dadada",
	selection_bg  = "#2d2d2d",  -- Visual bg from config
	ansi = {
		"#1a1a1a",  -- 0 black
		"#d59192",  -- 1 red
		"#b3b393",  -- 2 green
		"#bfaf8e",  -- 3 yellow
		"#a8a1be",  -- 4 blue
		"#b99bb5",  -- 5 magenta
		"#a8a1be",  -- 6 cyan
		"#dadada",  -- 7 white
	},
	brights = {
		"#242424",  -- 8 bright black
		"#ffbcbd",  -- 9 bright red
		"#dfdfbe",  -- 10 bright green
		"#ecdbb9",  -- 11 bright yellow
		"#d4cdeb",  -- 12 bright blue
		"#e6c6e1",  -- 13 bright magenta
		"#d4cdeb",  -- 14 bright cyan
		"#dadada",  -- 15 bright white
	},
	tab_bar = {
		background   = "#161616",  -- dark_bg = bg-2.5%L
		active_tab   = { bg_color = "#282828", fg_color = "#dedede" },
		inactive_tab = { bg_color = "#161616", fg_color = "#636363" },
		new_tab      = { bg_color = "#161616", fg_color = "#282828" },
	},
}

-- Kanagawa custom colors for wezterm (Dragon variant)
local kanagawa_colors = {
	foreground    = "#C5C9C5",
	background    = "#181616",
	cursor_bg     = "#C8C093",
	cursor_fg     = "#181616",
	cursor_border = "#C8C093",
	selection_fg  = "#C5C9C5",
	selection_bg  = "#223249",
	ansi = {
		"#0D0C0C",
		"#C4746E",
		"#8A9A7B",
		"#C4B28A",
		"#8BA4B0",
		"#A292A3",
		"#8EA4A2",
		"#C8C093",
	},
	brights = {
		"#A6A69C",
		"#E46876",
		"#87A987",
		"#E6C384",
		"#7FB4CA",
		"#938AA9",
		"#7AA89F",
		"#C5C9C5",
	},
	tab_bar = {
		background   = "#0D0C0C",
		active_tab   = { bg_color = "#181616", fg_color = "#C5C9C5" },
		inactive_tab = { bg_color = "#0D0C0C", fg_color = "#A6A69C" },
		new_tab      = { bg_color = "#0D0C0C", fg_color = "#181616" },
	},
}


-- Get theme from .zshenv file
local function get_theme()
	-- Try environment variable first (set when launched from shell)
	local theme = os.getenv("THEME") or os.getenv("WEZTERM_THEME")
	
	-- If not in env, read from .zshenv file
	if not theme or theme == "" then
		-- Try dotfiles location first, then XDG config
		local zshenv_paths = {
			os.getenv("HOME") .. "/dotfiles/zsh/.zshenv",
			os.getenv("HOME") .. "/.config/zsh/.zshenv",
			os.getenv("HOME") .. "/.zshenv",
		}
		for _, path in ipairs(zshenv_paths) do
			local file = io.open(path, "r")
			if file then
				for line in file:lines() do
					local match = line:match('export%s+THEME%s*=%s*"([^"]+)"')
								  or line:match("export%s+THEME%s*=%s*'([^']+)'")
								  or line:match('export%s+THEME%s*=%s*([^%s#]+)')
					if match then
						theme = match
						break
					end
				end
				file:close()
				if theme and theme ~= "" then break end
			end
		end
	end
	
	return theme or "anysphere"
end

local theme = get_theme()
-- Debug: log the theme being used
wezterm.log_info("WezTerm theme detected: " .. (theme or "nil"))

-- Apply theme
if theme == "anysphere" then
	config.colors = anysphere_colors
	wezterm.log_info("Applied anysphere custom colors")
elseif theme == "catppuccin" then
	config.color_scheme = "Catppuccin Mocha"
	wezterm.log_info("Applied Catppuccin Mocha")
elseif theme == "onedark" then
	config.colors = onedark_colors
	wezterm.log_info("Applied OneDark custom colors")
elseif theme == "mellifluous" then
	config.colors = mellifluous_colors
	wezterm.log_info("Applied Mellifluous custom colors")
elseif theme == "kanagawa" then
	config.colors = kanagawa_colors
	wezterm.log_info("Applied Kanagawa custom colors")
elseif theme == "tokyonight" then
	config.color_scheme = "tokyonight_night"
	wezterm.log_info("Applied Tokyo Night")
else
	-- Default to anysphere
	config.colors = anysphere_colors
	wezterm.log_info("Applied default: anysphere")
end

return config
