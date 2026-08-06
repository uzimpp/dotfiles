local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_cursor_style = "SteadyBar"
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.check_for_updates = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_resize_increments = true

config.font = wezterm.font("JetbrainsMono Nerd Font", { weight = "Regular" })
config.font_size = 15
config.custom_block_glyphs = true
config.cell_width = 1.0
config.line_height = 1.0
config.enable_tab_bar = true
config.window_padding = {
	left = 4,
	right = 0,
	top = 0,
	bottom = 0,
}
-- Dim inactive panes by reducing their brightness and saturation
config.inactive_pane_hsb = {
  hue = 1.0,         -- default value (no change)
  saturation = 0.9,  -- reduce saturation by 50%
  brightness = 1.0, -- reduce brightness by 25% (dimming)
}
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Key bindings
config.keys = {
	-- Custom Enter key mappings
	{ key = "Enter", mods = "CTRL", action = wezterm.action({ SendString = "\x1b[13;5u" }) },
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b[13;2u" }) },

	-- Split panes (useful for running commands while coding)
	{ key = "|", mods = "CTRL|SHIFT", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "-", mods = "CTRL|SHIFT", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },

	-- Navigate between panes
	{ key = "h", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "l", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	{ key = "k", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "j", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Down" }) },

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
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

smart_splits.apply_to_config(config, {
  direction_keys = {
    move = { 'h', 'j', 'k', 'l' },
    resize = { 'LeftArrow', 'DownArrow', 'UpArrow', 'RightArrow' },
  },
  -- modifier keys to combine with direction_keys
  modifiers = {
    move = 'CTRL', -- modifier to use for pane movement, e.g. CTRL+h to move left
    resize = 'META', -- modifier to use for pane resize, e.g. META+h to resize to the left
  },
  -- log level to use: info, warn, error
  log_level = 'info',
})
-- Theme is set in wezterm.lua after config is loaded
return config
