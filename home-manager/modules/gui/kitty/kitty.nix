{
  pkgs,
  config,
  ...
}:
{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;

    font = {
      name = "HackGen35 Console NF";
      package = pkgs.hackgen-nf-font;
      size = 12;
    };

    themeFile = "kanagawa";

    settings = {
      background_opacity = 0.70;
      background_blur = 0;
      hide_window_decorations = "yes";
      window_padding_width = "6 4";
      cursor_shape = "beam";
      cursor_blink_interval = 0;
      mouse_hide_wait = "-1.0";

      # Tab
      tab_bar_edge = "top";
      tab_bar_style = "fade";
      tab_bar_min_tabs = 2;
      # Tab title
      tab_title_template = "{fmt.fg.tab}{'/'.join(tab.active_wd.replace('${config.home.homeDirectory}', '~').split('/')[-2:])}";
      active_tab_title_template = "{fmt.fg.tab}{'/'.join(tab.active_wd.replace('${config.home.homeDirectory}', '~').split('/')[-2:])}";

      # Disable hyperlink
      allow_hyperlinks = "no";

      # アクティブでなくて、時間がかかるコマンドが終了したら通知
      notify_on_cmd_finish = "unfocused 7.5";
    };

    keybindings = {
      "ctrl+shift+1" = "goto_tab 1";
      "ctrl+shift+2" = "goto_tab 2";
      "ctrl+shift+3" = "goto_tab 3";
      "ctrl+shift+4" = "goto_tab 4";
      "ctrl+shift+5" = "goto_tab 5";
      "ctrl+shift+6" = "goto_tab 6";
      "ctrl+shift+7" = "goto_tab 7";
      "ctrl+shift+8" = "goto_tab 8";
      "ctrl+shift+9" = "goto_tab 9";

      "ctrl+shift+t" = "new_tab_with_cwd";
      "ctrl+tab" = "next_tab";
      "ctrl+shift+tab" = "previous_tab";
    };
  };
}
