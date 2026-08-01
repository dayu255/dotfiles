{
  pkgs,
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/.config/wallpapers/wallpaper.png"
      ];
      wallpaper = [
        {
          monitor = "";
          path = "~/.config/wallpapers/wallpaper.png";
        }
      ];
    };
  };
}
