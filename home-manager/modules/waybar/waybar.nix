{
  pkgs,
  ...
}:
{
  imports = [
    ../wlogout/wlogout.nix
  ];

  programs.waybar = {
    enable = true;
  };

  xdg.configFile = {
    "waybar/config.jsonc".source = ./config.jsonc;
    "waybar/style.css".source = ./style.css;
    "waybar/script/docker-container".source = ./script/docker-container.sh;
    # "waybar/reload.sh".source = ./reload.sh;
  };
}
