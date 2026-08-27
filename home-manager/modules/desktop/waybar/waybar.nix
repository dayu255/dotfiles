{
  pkgs,
  ...
}:
{
  programs.waybar = {
    enable = true;
  };

  home.packages = with pkgs; [
    jq
  ];

  xdg.configFile = {
    "waybar/config.jsonc".source = ./config.jsonc;
    "waybar/style.css".source = ./style.css;
    "waybar/script/docker".source = ./script/docker.sh;
    "waybar/script/podman".source = ./script/podman.sh;
    "waybar/script/ip-info".source = ./script/ip-info.sh;
    "waybar/script/tailscale".source = ./script/tailscale.sh;
  };
}
