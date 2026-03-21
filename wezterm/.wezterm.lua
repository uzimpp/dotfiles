local wezterm = require("wezterm")
local home = os.getenv("HOME")
package.path = package.path .. ";" .. home .. "/?.lua"

local config = require("config")
require("events")

local function get_shell_colors()
    local ok, stdout, _ = wezterm.run_child_process({
        "/bin/zsh", "-c",
        "env"
    })

    local vars = {}
    if ok then
        for line in stdout:gmatch("[^\n]+") do
            local key, val = line:match("^(COLOR[%w_]*)=(.+)$")  -- only COLOR* vars
            if key and val then
                vars[key] = val
        end
    end
    end
    return vars
end

local env = get_shell_colors()

local function load_colors()
    local ansi, brights = {}, {}
    for i = 0, 7  do ansi[i + 1]    = env["COLOR" .. i] or "#000000" end
    for i = 8, 15 do brights[i - 7] = env["COLOR" .. i] or "#000000" end

    return {
        foreground    = env.COLOR_FG           or "#cccccc",
        background    = env.COLOR_BG           or "#141414",
        cursor_bg     = env.COLOR_CURSOR       or "#cccccc",
        cursor_fg     = env.COLOR_BG           or "#141414",
        cursor_border = env.COLOR_CURSOR       or "#cccccc",
        selection_fg  = env.COLOR_SELECTION_FG or "#454545",
        selection_bg  = env.COLOR_SELECTION_BG or "#2d2d2d",
        ansi    = ansi,
        brights = brights,
        tab_bar = {
            background   = env.COLOR_TAB_BG          or "#141414",
            active_tab   = { bg_color = env.COLOR_TAB_ACTIVE_BG  or "#1a1a1a", fg_color = env.COLOR_TAB_ACTIVE_FG   or "#AEAEAE" },
            inactive_tab = { bg_color = env.COLOR_TAB_BG         or "#141414", fg_color = env.COLOR_TAB_INACTIVE_FG or "#636363" },
            new_tab      = { bg_color = env.COLOR_TAB_BG         or "#141414", fg_color = env.COLOR_TAB_INACTIVE_FG or "#636363" },
        },
    }
end

config.colors = load_colors()

return config
