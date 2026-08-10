{
  config,
  pkgs,
  inputs,
  lib,
  username,
  zen-browser,
  antigravity,
  walker,
  plasma-manager,
  ...
}:
{
  imports = [
    # Desktop
    ../../home-manager/modules/desktop/hyprland/hyprland.nix
    ../../home-manager/modules/desktop/plasma/plasma.nix
  ];

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "25.11"; # Please read the comment before changing.

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Creative
    gimp
    kdePackages.kdenlive
    audacity

    # File
    qbittorrent

    # Social
    vesktop # ごめんなさい。本当にhyprlandでdiscordがうまくいきませんでした。
    thunderbird

    # Local LLM
    lmstudio

    # LaTeX
    #texliveBasic

    # Unity
    #unityhub

    # Blender
    #blender
  ];

  # Env Var
  home.sessionVariables = {
    # Electron
    NIXOS_OZONE_WL = "1";

    # fcitx
    # GTK_IM_MODULE = "fcitx";
    # QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
}
