{
  pkgs,
  ...
}:
{
  programs.fastfetch.enable = true;
  xdg.configFile."fastfetch/config.jsonc".source = ./nixos-01.jsonc;
  xdg.configFile."fastfetch/logo".source = ./logo/nixos_logo_1.webp;
}
