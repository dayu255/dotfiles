{
  config,
  pkgs,
  inputs,
  lib,
  username,
  ...
}:
{
  imports = [
    ./modules/ssh/ssh.nix
    ./modules/zed/zed.nix
    ./modules/zsh/zsh.nix
    ./modules/ghostty/ghostty.nix
    ./modules/git/git.nix
    ./modules/hyprland/hyprland.nix
  ];

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "25.11"; # Please read the comment before changing.

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # ZenBrowser!!!
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default

    # Terminal
    wezterm

    # Editer
    vim-full
    neovim
    vscode
    wl-clipboard

    # Creative
    gimp
    kdePackages.kdenlive
    audacity

    # NixTools
    nh
    nvd
    nix-output-monitor
    nixfmt

    # Git/GitHub
    github-cli
    gh-dash
    cz-cli
    lazygit
    delta
    onefetch

    # Monitor
    fastfetch
    speedtest-cli
    htop
    btop
    bottom
    procs
    ncdu
    dust

    # file
    yazi
    eza
    fzf
    ouch
    ripgrep
    duf
    zoxide

    # Network
    dig
    whois
    oha

    # Auth / Security
    gnupg
    yubikey-manager
    cloudflared
    openssl

    # SNS
    discord
    vesktop
    signal-desktop
    thunderbird

    # etc
    lmstudio
    qbittorrent
    bruno
    podman

    # LaTeX
    # texliveBasic

    # Unity
    # unityhub

    # Blender
    # blender

    # C/C++
    gcc
    gdb
    gnumake
    clang-tools
    ac-library

    # Kawaii
    cbonsai
    asciiquarium-transparent

    # SQL
    # sqruff

    # Ruby
    ruby

    # go
    go
    cobra-cli
    goreleaser

    # BEAMs
    # beam28Packages.erlang
    # beam28Packages.elixir
    # gleam

    # Python
    uv

    # JS/TS
    nodejs_26
    typescript
    bun
    yarn

    # Rust
    # rustc
    # cargo
    # rustfmt
    # clippy
    # rust-analyzer

    # Haskell
    ghc
    cabal-install

    # Antigravity
    inputs.antigravity-nix.packages.x86_64-linux.default # Base App
    inputs.antigravity-nix.packages.x86_64-linux.google-antigravity-ide # IDE
    inputs.antigravity-nix.packages.x86_64-linux.google-antigravity-cli # CLI

    # qrun
    (writeShellApplication {
      name = "qrun";
      text = ''
        export CPLUS_INCLUDE_PATH="${pkgs.ac-library}/include"
        ${builtins.readFile ../pkgs/qrun/qrun.sh}
      '';
    })

    # nix-template
    (writeShellApplication {
      name = "nix-template";
      runtimeInputs = [ pkgs.coreutils ];
      text = ''
        FLAKE_NIX_TEMPLATE="${../pkgs/nix-template/flake.nix.template}"
        ${builtins.readFile ../pkgs/nix-template/nix-template.sh}
      '';
    })
  ];

  # config files
  home.file = {
    ".npmrc".text = ''
      prefix=${config.home.homeDirectory}/.npm-global
    '';
    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/config/nvim";
    ".vimrc".source = ./config/vim/vimrc;
    ".czrc".text = ''
      {
      "path": "cz-conventional-changelog"
      }
    '';
  };
  xdg.configFile = {
    "wezterm/wezterm.lua".source = ./config/wezterm/wezterm.lua;
    "fcitx5/profile".source = ./config/fcitx5/profile;
    "yazi/yazi.toml".source = ./config/yazi/yazi.toml;
    "fastfetch/config.jsonc".source = ./config/fastfetch/nixos-01.jsonc;
  };

  # 環境変数
  home.sessionVariables = {
    PATH = "$HOME/.npm-global/bin:$PATH";
    EDITOR = "vim";
    TERMINAL = "wezterm";
    # C++のAtCoderライブラリを読み込ませる
    CPATH = "${config.home.homeDirectory}/.nix-profile/include";

    NIXOS_OZONE_WL = "1";
    # fcitx
    # GTK_IM_MODULE = "fcitx";
    # QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";

    # ROS2
    ROS_DOMAIN_ID = "42";
    SSH_ASKPASS_REQUIRE = "never";
  };

  # bat
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batgrep
      batdiff
      batman
    ];
    config = {
      theme = "Catppuccin Frappe";
    };
  };

  # SDDM(display manager) Wallpaper
  programs.plasma = {
    enable = true;
    kscreenlocker.appearance = {
      wallpaper = "${../assets/flower.png}";
    };
  };

  # Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  xdg.configFile."starship.toml".source = ./config/starship/starship.toml;

  # Direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # GPG-agent(パスワード打つところ)
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
    enableZshIntegration = true;
  };
}
