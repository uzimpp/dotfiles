local wezterm = require("wezterm")
-- HOME on macOS/Linux/WSL, USERPROFILE on native Windows, "." as a last resort.
local home = os.getenv("HOME") or os.getenv("USERPROFILE") or "."
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

-- Mellifluous theme — fallback when COLOR* env vars are unavailable
local fallback = {
    fg            = "#cccccc",
    bg            = "#141414",
    cursor        = "#cccccc",
    selection_fg  = "#cccccc",
    selection_bg  = "#2d2d2d",
    tab_bg        = "#141414",
    tab_active_bg = "#1a1a1a",
    tab_active_fg = "#AEAEAE",
    tab_inactive  = "#636363",
    ansi = {
        "#2d2d2d", "#d59192", "#97b393", "#bfb68e",
        "#a1a5be", "#b99bb3", "#a1b0be", "#AEAEAE",
    },
    brights = {
        "#4d4d4d", "#d59192", "#97b393", "#bfb68e",
        "#a1a5be", "#b99bb3", "#a1b0be", "#cccccc",
    },
}

local function load_colors()
    local ansi, brights = {}, {}
    for i = 0, 7  do ansi[i + 1]    = env["COLOR" .. i] or fallback.ansi[i + 1]    end
    for i = 8, 15 do brights[i - 7] = env["COLOR" .. i] or fallback.brights[i - 7] end

    return {
        foreground    = env.COLOR_FG           or fallback.fg,
        background    = env.COLOR_BG           or fallback.bg,
        cursor_bg     = env.COLOR_CURSOR       or fallback.cursor,
        cursor_fg     = env.COLOR_BG           or fallback.bg,
        cursor_border = env.COLOR_CURSOR       or fallback.cursor,
        selection_fg  = env.COLOR_SELECTION_FG or fallback.selection_fg,
        selection_bg  = env.COLOR_SELECTION_BG or fallback.selection_bg,
        ansi    = ansi,
        brights = brights,
        tab_bar = {
            background   = env.COLOR_TAB_BG          or fallback.tab_bg,
            active_tab   = { bg_color = env.COLOR_TAB_ACTIVE_BG  or fallback.tab_active_bg, fg_color = env.COLOR_TAB_ACTIVE_FG   or fallback.tab_active_fg },
            inactive_tab = { bg_color = env.COLOR_TAB_BG         or fallback.tab_bg,        fg_color = env.COLOR_TAB_INACTIVE_FG or fallback.tab_inactive },
            new_tab      = { bg_color = env.COLOR_TAB_BG         or fallback.tab_bg,        fg_color = env.COLOR_TAB_INACTIVE_FG or fallback.tab_inactive },
        },
    }
end

config.colors = load_colors()

return config
