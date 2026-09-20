{
  pkgs,
  ...
}:
{
  imports = [
    ../hazkey/hazkey.nix
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  home.packages = with pkgs; [
    papirus-icon-theme
    adwaita-icon-theme
  ];

  xdg.configFile."fcitx5/profile".source = ./profile;
  xdg.configFile."fcitx5/conf/mozc.conf".source = ./mozc.conf;
}
