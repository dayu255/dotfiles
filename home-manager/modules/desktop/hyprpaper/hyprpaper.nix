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
        "~/.config/hrprpaper/wallpaper.png"
        "~/.config/hyprpaper/IMG_0086.JPEG"
        "${../../../../assets/cherry_blossom_night.jpeg}"
      ];
      wallpaper = [
        {
          monitor = "";
          path = "~/.config/hyprpaper/IMG_0086.JPEG";
          # path = "~/.config/hyprpaper/wallpaper.png";
          # path = "${../../../../assets/cherry_blossom_night.jpeg}";
        }
      ];
    };
  };
}
