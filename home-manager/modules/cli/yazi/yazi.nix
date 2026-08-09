{
  pkgs,
  ...
}:
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };
  xdg.configFile."yazi/yazi.toml".source = ./yazi.toml;
}
