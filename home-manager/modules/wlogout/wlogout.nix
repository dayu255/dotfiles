{
  pkgs,
  ...
}:
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "shutdown";
        action = "${pkgs.systemd}/bin/systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "${pkgs.systemd}/bin/systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "logout";
        action = "${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.exit()'";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "${pkgs.systemd}/bin/systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
    ];
  };
}
