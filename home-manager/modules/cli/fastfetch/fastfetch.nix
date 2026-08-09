{
  pkgs,
  ...
}:
{
  programs.fastfetch.enable = true;
  xdg.configFile."fastfetch/config.jsonc".source = ./nixos-01.jsonc;
}
