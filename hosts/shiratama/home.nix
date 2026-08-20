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
let
  qrun = pkgs.callPackage ../../pkgs/qrun/qrun.nix { };
  nix-template = pkgs.callPackage ../../pkgs/nix-template/nix-template.nix { };
in
{
  imports = [
    # Desktop
    ../../home-manager/modules/desktop/hyprland/hyprland.nix
    ../../home-manager/modules/desktop/plasma/plasma.nix

    # GUI
    ../../home-manager/modules/gui/zed/zed.nix
    ../../home-manager/modules/gui/ghostty/ghostty.nix
    ../../home-manager/modules/gui/wezterm/wezterm.nix
    ../../home-manager/modules/gui/fcitx/fcitx.nix
  ];

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "25.11"; # Please read the comment before changing.

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Browser
    google-chrome
    # ZenBrowser!!!
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default

    # Editer
    vscode
    wl-clipboard

    # Creative
    gimp
    kdePackages.kdenlive
    audacity

    # File
    qbittorrent

    # English Grammer
    harper

    # Social
    vesktop # ごめんなさい。本当にhyprlandでdiscordがうまくいきませんでした。
    thunderbird
    discord
    signal-desktop

    # Auth/Security
    yubikey-manager
    cloudflared

    onlyoffice-desktopeditors

    # BenchMark
    oha

    # API Client
    bruno

    # Contaienr
    podman

    # Local LLM
    lmstudio

    # Unity
    #unityhub

    # Blender
    #blender

    # LaTeX
    #texliveBasic

    # C/C++
    gcc
    gdb
    gnumake
    clang-tools
    ac-library

    # Golang
    go
    go-tools

    # JS/TS
    nodejs
    typescript
    bun

    # Antigravity
    inputs.antigravity.packages.x86_64-linux.default # Base App
    inputs.antigravity.packages.x86_64-linux.google-antigravity-ide # IDE
    inputs.antigravity.packages.x86_64-linux.google-antigravity-cli # CLI

    # Homemade pkgs
    qrun
    nix-template
  ];

  # Env Var
  home.sessionVariables = {
    # for `nh` command
    NH_FLAKE = "${config.home.homeDirectory}/dotfiles";

    TERMINAL = "ghostty";
    # Electron
    NIXOS_OZONE_WL = "1";

    # fcitx
    # GTK_IM_MODULE = "fcitx";
    # QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";

    # nixpkgs#ac-library
    CPATH = "${config.home.homeDirectory}/.nix-profile/include";

    # no gui when enter passphrase
    SSH_ASKPASS_REQUIRE = "never";
  };

  # GPG-agent(passphrase)
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
    enableZshIntegration = true;
  };
}
