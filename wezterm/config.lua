local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_cursor_style = "SteadyBar"
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
-- config.window_decorations = "TITLE"
config.check_for_updates = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
-- Font Configuration
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
config.font_size = 17

-- Disable WezTerm's custom block glyphs to use font's shade characters (fixes ASCII art)
config.custom_block_glyphs = true

-- Line height (1.0 = default, 1.2 = 20% more space between lines)
-- Using 1.0 to prevent bottom padding issues - extra line spacing causes window/grid mismatch
config.line_height = 1.0

-- -- Letter spacing (cell width multiplier, 1.0 = default)
config.cell_width = 1.0

-- Disable ligatures if you prefer (uncomment to disable)
-- config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.enable_tab_bar = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
-- config.background = {
-- 	{
-- 		source = {
-- 			File = "/Users/" .. os.getenv("USER") .. "/.config/wezterm/dark-desert.jpg",
-- 		},
-- 		hsb = {
-- 			hue = 1.0,
-- 			saturation = 1.02,
-- 			brightness = 0.25,
-- 		},
-- 		-- attachment = { Parallax = 0.3 },
-- 		-- width = "100%",
-- 		-- height = "100%",
-- 	},
-- 	{
-- 		source = {
-- 			Color = "#0D1117",
-- 		},
-- 		width = "100%",
-- 		height = "100%",
-- 		-- opacity = 0.55,
-- 		opacity = 0.75,
-- 		-- opacity = 1,
-- 	},
-- }
-- config.window_background_opacity = 0.3
-- config.macos_window_background_blur = 20
-- Key bindings
config.keys = {
	-- Custom Enter key mappings
	{ key = "Enter", mods = "CTRL", action = wezterm.action({ SendString = "\x1b[13;5u" }) },
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b[13;2u" }) },
	
	-- Split panes (useful for running commands while coding)
	{ key = "|", mods = "CTRL|SHIFT", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "-", mods = "CTRL|SHIFT", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	
	-- Navigate between panes
	{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "j", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	
	-- Close pane
	{ key = "x", mods = "CTRL|SHIFT", action = wezterm.action({ CloseCurrentPane = { confirm = false } }) },
	
	-- New tab
	{ key = "t", mods = "CTRL|SHIFT", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	
	-- Navigate tabs
	{ key = "[", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },
	{ key = "]", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = 1 }) },
}
-- from: https://akos.ma/blog/adopting-wezterm/
config.hyperlink_rules = {
	-- Matches: a URL in parens: (URL)
	{
		regex = "\\((\\w+://\\S+)\\)",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in brackets: [URL]
	{
		regex = "\\[(\\w+://\\S+)\\]",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in curly braces: {URL}
	{
		regex = "\\{(\\w+://\\S+)\\}",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in angle brackets: <URL>
	{
		regex = "<(\\w+://\\S+)>",
		format = "$1",
		highlight = 1,
	},
	-- Then handle URLs not wrapped in brackets
	{
		regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
		format = "$1",
		highlight = 1,
	},
}

-- Theme is set in wezterm.lua after config is loaded
return config
