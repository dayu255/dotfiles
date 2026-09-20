{
  config,
  pkgs,
  inputs,
  username,
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
    ../../home-manager/modules/gui/kitty/kitty.nix
    ../../home-manager/modules/gui/fcitx/fcitx.nix
  ];

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "25.11"; # Please read the comment before changing.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Browser
    chromium
    # ZenBrowser!!!
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default

    # Editer
    vscode

    # Creative
    obs-studio
    gimp
    kdePackages.kdenlive
    audacity
    xnconvert

    # File
    qbittorrent

    # English Grammer
    harper

    # Social
    discord
    vesktop # ごめんなさい。本当にhyprlandでdiscordがうまくいきませんでした。
    thunderbird
    signal-desktop

    # Auth/Security
    yubikey-manager
    cloudflared

    # BenchMark
    oha

    # API Client
    bruno

    # Contaienr
    podman
    podman-compose

    # Local LLM
    # lmstudio

    # Unity
    #unityhub

    # Blender
    #blender

    # LaTeX
    #texliveBasic

    # Go LSP
    gopls

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

    # 画面共有: NVIDIA PRIME で DMA-BUF が壊れるため SHM を強制
    XDG_DESKTOP_PORTAL_HYPRLAND_FORCE_SHM = "1";
  };

  # GPG-agent(passphrase)
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
    enableZshIntegration = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen.desktop";
      "application/xhtml+xml" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/discord" = "discord.desktop";
      "x-scheme-handler/bruno" = "bruno.desktop";
    };
  };

  # Vesktop: NixOSのラッパーはflags.confを読まないため、.desktopで直接フラグを渡す
  xdg.desktopEntries.vesktop = {
    name = "Vesktop";
    comment = "Alternative Discord client with Vencord built-in";
    icon = "vesktop";
    exec = "vesktop --enable-features=WebRTCPipeWireCapturer %U";
    categories = [
      "Network"
      "InstantMessaging"
      "Chat"
    ];
    mimeType = [ "x-scheme-handler/discord" ];
    settings = {
      Keywords = "discord;vencord;electron;chat";
      StartupWMClass = "Vesktop";
    };
  };

  fonts.fontconfig.enable = true;
}
