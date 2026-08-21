{
  ...
}:
{
  programs.ghostty = {
    enable = true;

    settings = {
      # Fonts
      font-family = "HackGen35 Console NF";
      font-size = 12;

      # Appearance
      theme = "Kanagawa Wave";
      background-opacity = 0.70;
      background-blur-radius = 20;
      window-decoration = false;
      window-padding-x = 6;
      window-padding-y = 4;
      cursor-style = "block";
      cursor-style-blink = false;
      mouse-hide-while-typing = true;

      # Keybinds
      keybind = [
        "ctrl+shift+1=goto_tab:1"
        "ctrl+shift+2=goto_tab:2"
        "ctrl+shift+3=goto_tab:3"
        "ctrl+shift+4=goto_tab:4"
        "ctrl+shift+5=goto_tab:5"
        "ctrl+shift+6=goto_tab:6"
        "ctrl+shift+7=goto_tab:7"
        "ctrl+shift+8=goto_tab:8"
        "ctrl+shift+9=goto_tab:9"
      ];
    };
  };
}
