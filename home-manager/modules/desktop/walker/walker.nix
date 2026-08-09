{
  pkgs,
  walker,
  ...
}:
{
  # home.packages = with pkgs; [
  #   elephant
  # ];
  # services.walker = {
  #   enable = true;
  #   systemd.enable = true;
  #   settings = {
  #     terminal = "wezterm-gui";
  #   };
  # };

  programs.walker = {
    enable = true;
    runAsService = true;
    config = {
    };
  };

  xdg.configFile."elephant/elephant.toml".text = ''
    [providers.runner]
    terminal = "wezterm-gui"
  '';

  xdg.configFile."elephant/runner.toml".text = ''
    terminal = "wezterm"
  '';

  xdg.configFile."elephant/desktop_applications.toml".text = ''
    terminal = "wezterm"
  '';
}
