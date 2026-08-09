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

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    xdgOpenUsePortal = true;
    config = {
      # Hyprlandセッション用
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
      };
      # その他セッション（KDE等）用フォールバック
      common.default = [ "gtk" ];
    };
  };

  # services.xremap.withWlroots = true; # for xremap to work with wlroots
  # security.pam.services.swaylock.text = "auth include login";
}
