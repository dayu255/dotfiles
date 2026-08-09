{
  pkgs,
  plasma-manager,
  ...
}:
{
  programs.plasma = {
    enable = true;
    kscreenlocker.appearance.wallpaper = "${../../../../assets/flower.png}";
  };
}
