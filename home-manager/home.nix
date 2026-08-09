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
  qrun = pkgs.callPackage ../pkgs/qrun/qrun.nix { };
  nix-template = pkgs.callPackage ../pkgs/nix-template/nix-template.nix { };
in
{
  imports = [
    # Desktop
    ./modules/desktop/hyprland/hyprland.nix
    ./modules/desktop/plasma/plasma.nix

    # CLI
    ./modules/cli/zsh/zsh.nix
    ./modules/cli/starship/starship.nix
    ./modules/cli/vim/vim.nix
    ./modules/cli/nvim/nvim.nix
    ./modules/cli/ssh/ssh.nix
    ./modules/cli/git/git.nix
    ./modules/cli/bat/bat.nix
    ./modules/cli/yazi/yazi.nix
    ./modules/cli/direnv/direnv.nix
    ./modules/cli/fastfetch/fastfetch.nix

    # GUI
    ./modules/gui/zed/zed.nix
    ./modules/gui/ghostty/ghostty.nix
    ./modules/gui/wezterm/wezterm.nix
    ./modules/gui/fcitx/fcitx.nix
  ];

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "25.11"; # Please read the comment before changing.

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # ZenBrowser!!!
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default

    # Editer
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
    speedtest-cli
    htop
    btop
    bottom
    procs
    ncdu
    dust

    # File
    eza
    fzf
    ouch
    ripgrep
    duf
    zoxide
    qbittorrent

    # Network
    dig
    whois
    oha

    # Auth / Security
    openssl
    gnupg
    yubikey-manager
    cloudflared

    # Social
    discord
    vesktop # ごめんなさい。ほんとにhyprlandでdiscordがうまくいかなかったんです
    signal-desktop
    thunderbird

    # Local LLM
    lmstudio

    # API Client
    bruno

    # Contaienr
    podman

    # LaTeX
    #texliveBasic

    # Unity
    #unityhub

    # Blender
    #blender

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
    #sqruff

    # Ruby
    ruby

    # go
    go
    cobra-cli
    goreleaser

    # BEAMs
    #beam28Packages.erlang
    #beam28Packages.elixir
    #gleam

    # Python
    uv

    # JS/TS
    nodejs_26
    typescript
    bun
    yarn

    # Rust
    #rustc
    #cargo
    #rustfmt
    #clippy
    #rust-analyzer

    # Haskell
    ghc
    cabal-install

    # Antigravity
    inputs.antigravity.packages.x86_64-linux.default # Base App
    inputs.antigravity.packages.x86_64-linux.google-antigravity-ide # IDE
    inputs.antigravity.packages.x86_64-linux.google-antigravity-cli # CLI

    # Homemade pkgs
    qrun
    nix-template
  ];

  # Change install path when npm install -g
  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
  '';

  # Config Files
  home.file = {
    # commitizen(nixpkgs#cz-git)
    ".czrc".text = ''
      {
      "path": "cz-conventional-changelog"
      }
    '';
  };

  # Env Var
  home.sessionVariables = {
    EDITOR = "vim";
    TERMINAL = "ghostty";

    # nixpkgs#ac-library
    CPATH = "${config.home.homeDirectory}/.nix-profile/include";

    # Electron
    NIXOS_OZONE_WL = "1";

    # fcitx
    # GTK_IM_MODULE = "fcitx";
    # QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";

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
