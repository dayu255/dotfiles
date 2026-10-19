{
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = {
      splash = false;
      preload = [
        "~/.config/wallpapers/wallpaper.png"
        "${../../../../assets/cherry_blossom_night.jpeg}"
      ];
      wallpaper = [
        {
          monitor = "";
          # path = "~/.config/wallpapers/wallpaper.png";
          path = "${../../../../assets/cherry_blossom_night.jpeg}";
        }
      ];
    };
  };
}
