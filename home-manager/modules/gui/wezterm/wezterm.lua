-- Pull in the wezterm API
local wezterm = require("wezterm")

local local_hostname = wezterm.hostname():lower()

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action

config.automatically_reload_config = true

-- wayland
config.enable_wayland = true

-- Appearance
config.color_scheme = "Kanagawa (Gogh)"
-- config.color_scheme = "Catppuccin Macchiato"
-- config.color_scheme = 'Rosé Pine'
config.font_size = 12
config.window_padding = {
    left = "0.9cell",
    right = "0.9cell",
    top = "0.35cell",
    bottom = "0.35cell",
}
config.font = wezterm.font_with_fallback({
    { family = "HackGen35 Console NF", weight = "Regular" },
    "Noto Sans Mono CJK JP",
})
config.use_ime = true
config.window_background_opacity = 0.70
config.wayland_window_background_blur = true
-- config.win_background_blur = true
config.window_decorations = "NONE"

config.default_cursor_style = "SteadyBlock"

config.use_fancy_tab_bar = true
config.tab_max_width = 80

config.window_frame = {
    inactive_titlebar_bg = "none",
    active_titlebar_bg = "none",
    font_size = 11.0,
}

config.window_background_gradient = {
    colors = { "#1F1F28" },
}

-- ランチャーメニュー
config.launch_menu = {
    {
        label = "Zsh",
        args = { "zsh", "-l" },
        cwd = wezterm.home_dir,
    },
    {
        label = "Bash",
        args = { "bash", "-l" },
        cwd = wezterm.home_dir,
    },
    {
        label = "System Monitor (htop)",
        args = { "htop" },
    },
}

config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.hide_tab_bar_if_only_one_tab = true

-- パスをフォーマットするヘルパー関数
local function format_path(cwd)
    cwd = cwd:gsub("\\", "/")
    cwd = cwd:gsub("/$", "")

    local is_absolute = cwd:sub(1, 1) == "/"

    local parts = {}
    for part in string.gmatch(cwd, "[^/]+") do
        table.insert(parts, part)
    end

    if #parts >= 2 then
        -- 親が ~ のときは ··· を付けず ~/xxx 形式にする
        if parts[#parts - 1] == "~" then
            return "~/" .. parts[#parts]
        else
            return "" .. parts[#parts - 1] .. "/" .. parts[#parts]
        end
    elseif #parts == 1 then
        -- 絶対パス (例: /etc) の場合は先頭の / を復元する
        if is_absolute then
            return "/" .. parts[1]
        else
            return parts[1]
        end
    end
    -- ルートディレクトリ "/" 自体
    return "/"
end

local ROUND_LEFT = wezterm.nerdfonts.ple_left_half_circle_thick   -- 
local ROUND_RIGHT = wezterm.nerdfonts.ple_right_half_circle_thick -- 

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local background = "#313244"
    local foreground = "#CDD6F4"
    local edge_background = "none"

    if tab.is_active then
        background = "#D27E99"
        foreground = "#1c2a4d"
    end

    local edge_foreground = background

    local pane = tab.active_pane
    local title = pane.title

    -- OSC 7 でシェルから通知されたカレントディレクトリを使用
    local cwd_uri = pane.current_working_dir
    if cwd_uri then
        local cwd = cwd_uri.file_path
        local host = cwd_uri.host

        if cwd and cwd ~= "" then
            -- ホームディレクトリを ~ に短縮
            local home = wezterm.home_dir
            if home then
                -- ルートパスに対するエスケープ処理
                cwd = cwd:gsub("^" .. home:gsub("([%.%+%-%*%?%[%]%^%$%(%)%%])", "%%%1"), "~")
            end

            -- rootディレクトリのフォールバック
            cwd = cwd:gsub("^/root(/.+)$", "~%1")
            if cwd == "/root" then
                cwd = "~"
            end

            local dir = format_path(cwd)

            -- SSH セッション: host がローカルマシン名でない場合のみ [hostname]dir 形式
            local remote_host = (host or ""):lower()
            -- ローカルとみなすホスト名のリスト
            local local_hosts = { local_hostname, "localhost" }
            local is_local = false
            for _, h in ipairs(local_hosts) do
                if remote_host == h then
                    is_local = true
                    break
                end
            end
            if remote_host ~= "" and not is_local then
                title = "[" .. host .. "]" .. dir
            else
                title = dir
            end
        end
    end

    title = " " .. title .. " "

    return {
        { Background = { Color = edge_background } },
        { Foreground = { Color = edge_foreground } },
        { Text = ROUND_LEFT },
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = title },
        { Background = { Color = edge_background } },
        { Foreground = { Color = edge_foreground } },
        { Text = ROUND_RIGHT },
    }
end)

-- キーバインド alt+L でローンチメニュー
config.keys = {
    {
        key = "l",
        mods = "ALT",
        action = act.ShowLauncherArgs({
            flags = "FUZZY|LAUNCH_MENU_ITEMS",
        }),
    },
    -- CTRL+SHIFT+数字でタブ移動 (IMEなどに横取りされる場合の明示的な定義)
    { key = "phys:1", mods = "CTRL|SHIFT", action = act.ActivateTab(0) },
    { key = "phys:2", mods = "CTRL|SHIFT", action = act.ActivateTab(1) },
    { key = "phys:3", mods = "CTRL|SHIFT", action = act.ActivateTab(2) },
    { key = "phys:4", mods = "CTRL|SHIFT", action = act.ActivateTab(3) },
    { key = "phys:5", mods = "CTRL|SHIFT", action = act.ActivateTab(4) },
    { key = "phys:6", mods = "CTRL|SHIFT", action = act.ActivateTab(5) },
    { key = "phys:7", mods = "CTRL|SHIFT", action = act.ActivateTab(6) },
    { key = "phys:8", mods = "CTRL|SHIFT", action = act.ActivateTab(7) },
    { key = "phys:9", mods = "CTRL|SHIFT", action = act.ActivateTab(8) },
}

-- and finally, return the configuration to wezterm
return config

-- OSC 7 カレントディレクトリ通知の設定
--
-- __wezterm_set_cwd() {
--         printf "\033]7;file://%s%s\033\\" "$HOSTNAME" "$PWD"
-- }
-- PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }__wezterm_set_cwd"
