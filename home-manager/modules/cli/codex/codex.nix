{
  pkgs,
  ...
}:
{
  programs.codex = {
    enable = true;
    context = ./AGENTS.md;
  };

  home.packages = with pkgs; [
    codex-acp
  ];
}
