{
  config,
  pkgs,
  username,
  ...
}:
{
  imports = [
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
  ];

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # NixTools
    nh
    nvd
    nix-output-monitor
    nixfmt
    nil
    nixd

    # Git/GitHub
    github-cli
    gh-dash
    cz-cli
    lazygit

    # Monitor
    bottom
    procs

    # File
    dust
    ncdu_1
    eza
    fzf
    ripgrep
    duf
    ouch

    # Auth / Security
    openssl
    gnupg
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
  };
}
