{
  pkgs,
  ...
}:
{
  programs.waybar = {
    enable = true;
  };

  xdg.configFile = {
    "waybar/config.jsonc".source = ./config.jsonc;
    "waybar/style.css".source = ./style.css;
    "waybar/script/docker-container".source = ./script/docker-container.sh;
    "waybar/script/ip-info".source = ./script/ip-info.sh;
    # "waybar/reload.sh".source = ./reload.sh;
  };
}
