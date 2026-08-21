{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

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

      # Copilot-CLI
      if (( $+commands[github-copilot-cli] )); then
        eval "$(github-copilot-cli alias -- zsh)"
      fi
    '';
  };
}
