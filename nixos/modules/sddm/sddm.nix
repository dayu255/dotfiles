{
  pkgs,
  ...
}:
{
  # SSDM(display manager)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "breeze";
  };
}
