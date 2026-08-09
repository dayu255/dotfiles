{
  pkgs,
  ...
}:
{
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batgrep
      batdiff
      batman
    ];
    config = {
      theme = "Catppuccin Macchiato";
    };
  };
}
