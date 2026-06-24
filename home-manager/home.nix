{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  myWallpaper = pkgs.fetchurl {
    url = "https://github.com/dayu255/assets/blob/main/flower.jpg?raw=true";
    name = "flower.jpg";
    hash = "sha256-2JcFtKoTr5f2XJLGzl0pcybD3LHM7QSQK+87W/ohgCc=";
  };
in
{
  home.username = "dayu";
  home.homeDirectory = "/home/dayu";

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
    wl-clipboard

    # NixTools
    nixfmt

    # Git/GitHub
    github-cli
    cz-cli
    lazygit
    onefetch

    # Monitor
    fastfetch
    speedtest-cli
    htop
    btop
    ncdu
    dust

    # file
    yazi
    eza
    fzf
    ouch

    # Network
    whois

    # Auth
    yubikey-manager
    cloudflared

    # etc
    lmstudio
    github-copilot-cli
    qbittorrent

    # SNS
    discord
    signal-desktop

    # LaTeX
    texliveBasic

    # Unity
    unityhub

    # Blender
    blender

    # C/C++
    gcc
    gdb
    gnumake
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

    # BEAM
    # erlang
    elixir
    # gleam

    # Python
    uv

    # JS/TS
    nodejs
    typescript
    bun
    yarn

    # Rust
    rustc
    cargo
    # rustfmt
    # clippy
    # rust-analyzer

    # Haskell
    ghc
    cabal-install

    # qrun
    (writeShellApplication {
      name = "qrun";
      text = ''
        export CPLUS_INCLUDE_PATH="${pkgs.ac-library}/include"
        ${builtins.readFile ./config/qrun.sh}
      '';
    })
  ];

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

  # git-cz
  home.file = {
    ".czrc".text = ''
      			{
      			"path": "cz-conventional-changelog"
      			}
      		'';
  };

  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
  '';

  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/config/nvim";

  home.file.".vimrc".source = ./config/vimrc;

  xdg.configFile."wezterm/wezterm.lua".source = ./config/wezterm.lua;
  xdg.configFile."fcitx5/profile".source = ./config/fcitx5/profile;
  xdg.configFile."yazi/yazi.toml".source = ./config/yazi.toml;
  xdg.configFile."fastfetch/config.jsonc".source = ./config/fastfetch/nixos-01.jsonc;

  # 環境変数
  home.sessionVariables = {
    PATH = "$HOME/.npm-global/bin:$PATH";
    NIXOS_OZONE_WL = "1";

    EDITOR = "vim";

    # C++のAtCoderライブラリを読み込ませる
    CPATH = "${config.home.homeDirectory}/.nix-profile/include";

    # fcitx
    # GTK_IM_MODULE = "fcitx";
    # QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";

    # ROS2
    ROS_DOMAIN_ID = "42";
  };

  # KDE Wallpaper
  programs.plasma = {
    enable = true;
    workspace = {
      wallpaper = "${pkgs.nixos-artwork.wallpapers.catppuccin-frappe}/share/backgrounds/nixos/nix-wallpaper-catppuccin-frappe.png";
    };
    kscreenlocker.appearance = {
      wallpaper = "${myWallpaper}";
    };
  };

  # Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = config.home.homeDirectory;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "golang"
        "rust"
        "npm"
        "fzf"
      ];
    };

    shellAliases = {
      proot = "cd $(git rev-parse --show-toplevel)";
      dcbuild = "docker compose up -d --build";

      "g++" = "g++ -I${pkgs.ac-library}/include";

      ls = "eza";
      ll = "eza -l";
      la = "eza -a";
      lla = "eza -la";
      lt = "eza -al -T -L 3";
    };

    initContent = ''
      			# WezTerm (OSC 7)
      			__wezterm_set_cwd() {
      				print -Pn "\e]7;file://%m$PWD\a"
      			}
      			chpwd_functions=(__wezterm_set_cwd $chpwd_functions)

      			# ssh-agent
      			eval "$(ssh-agent -s)" > /dev/null

      			# Copilot-CLI
      			if (( $+commands[github-copilot-cli] )); then
      			eval "$(github-copilot-cli alias -- zsh)"
      			fi
      		'';
  };

  # Thunderbird
  programs.thunderbird = {
    enable = true;
  };

  # Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  xdg.configFile."starship.toml".source = ./config/starship.toml;

  # Direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  # VScode
  programs.vscode = {
    enable = true;
  };

  # zed-editor
  programs.zed-editor = {
    enable = true;

    userSettings = {
      vim_mode = true;
      relative_line_numbers = "enabled";

      project_panel = {
        dock = "left";
      };
      buffer_font_family = "HackGen35 Console NF";
      buffer_font_size = 14;

      hide_mouse = "on_typing";
      format_on_save = "on";

      ui_font_family = "sans-serif";
      ui_font_size = 15;
      disable_ai = true;

      toolbar = {
        breadcrumbs = false;
        quick_actions = false;
        selections_menu = false;
        agent_review = false;
        code_actions = false;
      };

      collaboration_panel = {
        botton = false;
      };
      scrollbar = {
        show = "never";
      };
      minimap = {
        show = "never";
      };

      terminal = {
        dock = "bottom";
        font_family = "HackGen35 Console NF";
        blinking = "off";
        alternate_scroll = "on";
      };

      theme = "Kanagawa";
    };

    userTasks = [
      {
        label = "Run with qrun";
        command = "qrun";
        args = [
          "$ZED_FILE"
        ];
      }
    ];

    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "ctrl-alt-n" = [
            "task::Spawn"
            { task_name = "Run with qrun"; }
          ];
        };
      }
    ];

    extensions = [
      "nix"
      "dockerfile"
      "docker-compose"
      "html"
      "ruby"
      "kanagawa-themes"
    ];

    mutableUserSettings = true;
  };

  # GPG
  programs.gpg = {
    enable = true;
  };
  # GPG-agent(パスワード打つとこ)
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
    enableZshIntegration = true;
  };

  # Git
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "dayu";
        email = "dayu@dayu.jp";
        signingkey = "BF2D5F721420828E";
      };

      commit.gpgSign = true;
      init.defaultBranch = "main";

      # Git hubとの認証の設定
      "credential".helper = "!${pkgs.github-cli}/bin/gh auth git-credential";
      "credential \"https://github.com\"".helper = "!${pkgs.github-cli}/bin/gh auth git-credential";
      "credential \"https://gist.github.com\"".helper = "!${pkgs.github-cli}/bin/gh auth git-credential";
    };
  };
}
