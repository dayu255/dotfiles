{
  pkgs,
  lib,
  ...
}:
let
  lua = lib.generators.mkLuaInline;

  dsp = {
    exec = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';
    close = lua "hl.dsp.window.close()";
    exit = lua "hl.dsp.exit()";
    float = lua ''hl.dsp.window.float({ action = "toggle" })'';
    fullscreen = lua "hl.dsp.window.fullscreen()";
    pseudo = lua "hl.dsp.window.pseudo()";
    layout = msg: lua ''hl.dsp.layout("${msg}")'';
    focus = dir: lua ''hl.dsp.focus({ direction = "${dir}" })'';
    swap = dir: lua ''hl.dsp.window.swap({ direction = "${dir}" })'';
    toggleSpecial = name: lua ''hl.dsp.workspace.toggle_special("${name}")'';
    moveToSpecial = name: lua ''hl.dsp.window.move({ workspace = "special:${name}" })'';
    focusWorkspace = ws: lua ''hl.dsp.focus({ workspace = "${toString ws}" })'';
    moveToWorkspace = ws: lua ''hl.dsp.window.move({ workspace = "${toString ws}" })'';
    moveToMonitor = dir: lua ''hl.dsp.window.move({ monitor = "${dir}" })'';
    focusMonitor = dir: lua ''hl.dsp.focus({ monitor = "${dir}" })'';
    drag = lua "hl.dsp.window.drag()";
    resize = lua "hl.dsp.window.resize()";
    sendshortcut = mod: key: lua ''hl.dsp.send_shortcut({ mods = "${mod}", key = "${key}" })'';
  };

  bind = keys: dispatcher: { _args = [keys dispatcher]; };
  bindOpts = keys: dispatcher: opts: { _args = [keys dispatcher opts]; };

  workspaceBinds = lib.concatMap (i:
    let key = toString (lib.mod i 10);
    in [
      (bind "SUPER + ${key}" (dsp.focusWorkspace i))
      (bind "SUPER + SHIFT + ${key}" (dsp.moveToWorkspace i))
    ]
  ) (lib.range 1 10);

  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.hyprpolkitagent}/bin/hyprpolkitagent &
    ${pkgs.waybar}/bin/waybar &
    fcitx5 -d -r &
    ${pkgs.swayidle}/bin/swayidle -w \
      timeout 300 '${pkgs.hyprlock}/bin/hyprlock' \
      timeout 600 'hyprctl dispatch dpms off' \
        resume 'hyprctl dispatch dpms on' \
      before-sleep '${pkgs.hyprlock}/bin/hyprlock' &
  '';
in
{
  # dependency
  home.packages = with pkgs ; [
    kdePackages.dolphin
    grimblast
    hyprpolkitagent
    brightnessctl
    xdg-desktop-portal-gtk
    swayidle
    imv
    wf-recorder
  ];
  services.mako.enable = true;
  programs.walker.enable = true;
  # programs.rofi.enable = true;
  programs.hyprlock.enable = true;
  imports = [
    ../waybar/waybar.nix
    ../wlogout/wlogout.nix
    ../hyprpaper/hyprpaper.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    settings = {
      monitor = [
        {
          output = "eDP-1";
          mode = "preferred";
          position = "auto";
          scale = "1.25";
        }
        {
          output = "HDMI-A-1";
          mode = "highrr";
          position = "auto";
          scale = "1";
        }
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = "1";
        }
      ];

      config = {
        general = {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 2;
          col = {
            active_border = "rgb(aa7bff)";
            inactive_border = "rgb(19003b)";
          };
        };

        decoration = {
          rounding = 5;
          active_opacity = 0.975;
          inactive_opacity = 0.85;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        animations = {
          enabled = true;
        };

        dwindle = {
          force_split = 2;
          preserve_split = true;
        };

        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = true;
        };

        input = {
          kb_layout = "jp";
          follow_mouse = 0;
          sensitivity = -0.2;
          natural_scroll = false;
          touchpad = {
            natural_scroll = true;
          };
        };
      };

      curve = [{
        _args = [
          "myBezier"
          {
            type = "bezier";
            points = lua "{ {0.05, 0.9}, {0.1, 1.05} }";
          }
        ];
      }];

      animation = [
        { leaf = "windows"; enabled = true; speed = 7; bezier = "myBezier"; }
        { leaf = "windowsOut"; enabled = true; speed = 7; bezier = "default"; style = "popin 80%"; }
        { leaf = "border"; enabled = true; speed = 10; bezier = "default"; }
        { leaf = "borderangle"; enabled = true; speed = 8; bezier = "default"; }
        { leaf = "fade"; enabled = true; speed = 7; bezier = "default"; }
        { leaf = "workspaces"; enabled = true; speed = 6; bezier = "default"; }
      ];

      window_rule = [{
        match = {
          class = "^(kitty)$";
          title = "^(bw-unlock)$";
        };
        float = true;
      }];

      on = {
        _args = [
          "hyprland.start"
          (lua ''
            function()
              hl.exec_cmd("${startupScript}/bin/start")
            end'')
        ];
      };

      bind = [
        # App launchers
        (bind "SUPER + B" (dsp.exec "zen"))
        (bind "SUPER + W" (dsp.exec "wezterm-gui"))
        (bind "SUPER + Z" (dsp.exec "zeditor"))
        (bind "SUPER + E" (dsp.exec "dolphin"))
        # (bind "SUPER + SPACE" (dsp.exec "rofi -show drun"))
        (bind "SUPER + SPACE" (dsp.exec "walker"))
        (bind "SUPER + CTRL + V" (dsp.exec "walker -m clipboard"))
        (bind "SUPER + M" (dsp.exec "kitty nvim ~/Cortex/00_NOTES/temp.md"))

        # Screenshots
        (bind "SUPER + CTRL + 4" (dsp.exec "grimblast copysave area"))
        (bind "SUPER + CTRL + 5" (dsp.exec "grimblast copysave screen"))

        # Universal copy/paste
        (bind "SUPER + C" (dsp.sendshortcut "CTRL" "Insert"))
        (bind "SUPER + V" (dsp.sendshortcut "SHIFT" "Insert"))
        (bind "SUPER + X" (dsp.sendshortcut "CTRL" "X"))

        # Window management
        (bind "SUPER + Q" dsp.close)
        # (bind "SUPER + SHIFT + Q" dsp.exit)
        (bind "SUPER + CTRL + Q" (dsp.exec "wlogout -m 400"))
        (bind "SUPER + L" (dsp.exec "hyprlock"))
        (bind "SUPER + T" dsp.float)
        (bind "SUPER + F" dsp.fullscreen)
        (bind "SUPER + P" dsp.pseudo)
        (bind "SUPER + J" (dsp.layout "togglesplit"))

        # Focus
        (bind "SUPER + left" (dsp.focus "left"))
        (bind "SUPER + right" (dsp.focus "right"))
        (bind "SUPER + up" (dsp.focus "up"))
        (bind "SUPER + down" (dsp.focus "down"))

        # Swap windows
        (bind "SUPER + SHIFT + left" (dsp.swap "left"))
        (bind "SUPER + SHIFT + right" (dsp.swap "right"))
        (bind "SUPER + SHIFT + up" (dsp.swap "up"))
        (bind "SUPER + SHIFT + down" (dsp.swap "down"))

        # Special workspace
        (bind "SUPER + S" (dsp.toggleSpecial "magic"))
        (bind "SUPER + SHIFT + S" (dsp.moveToSpecial "magic"))
        (bind "SUPER + CTRL + S" (dsp.moveToWorkspace "e+0"))

        # Scroll through workspaces
        (bind "SUPER + mouse_down" (dsp.focusWorkspace "e+1"))
        (bind "SUPER + mouse_up" (dsp.focusWorkspace "e-1"))

        # Volume keys
        (bindOpts "XF86AudioRaiseVolume" (dsp.exec "wpctl set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 5%+") { locked = true; repeating = true; })
        (bindOpts "XF86AudioLowerVolume" (dsp.exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") { locked = true; repeating = true; })
        (bindOpts "XF86AudioMute" (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") { locked = true; })
        (bindOpts "XF86AudioMicMute" (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") { locked = true; })

        # Brightness keys
        (bindOpts "XF86MonBrightnessUp" (dsp.exec "brightnessctl -d intel_backlight set 5%+") { locked = true; repeating = true; })
        (bindOpts "XF86MonBrightnessDown" (dsp.exec "brightnessctl -d intel_backlight set 5%-") { locked = true; repeating = true; })

        # Mouse move/resize
        (bindOpts "SUPER + mouse:272" dsp.drag { mouse = true; })
        (bindOpts "SUPER + mouse:273" dsp.resize { mouse = true; })

        # Move window between monitors
        (bind "SUPER + ALT + left" (dsp.moveToMonitor "l"))
        (bind "SUPER + ALT + right" (dsp.moveToMonitor "r"))
        (bind "SUPER + ALT + up" (dsp.moveToMonitor "u"))
        (bind "SUPER + ALT + down" (dsp.moveToMonitor "d"))
      ] ++ workspaceBinds;
    };
  };
}
