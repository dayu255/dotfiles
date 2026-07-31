{
  pkgs,
  ...
}:

{
  programs.hyprland = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.kitty
  ];

  # programs.dconf.enable = true;
  # xdg.portal.enable = true;

  # services.xremap.withWlroots = true; # for xremap to work with wlroots
  # security.pam.services.swaylock.text = "auth include login";
}
