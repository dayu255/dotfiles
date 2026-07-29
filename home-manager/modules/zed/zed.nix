{ pkgs, lib, ... }:
{
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
        button = false;
      };
      scrollbar = {
        show = "auto";
        git_diff = false;
        diagnostics = "all";
        axes = {
          horizontal = true;
          vertical = true;
        };
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

      languages = {
        HTML = {
          tab_size = 2;
        };
        ERB = {
          tab_size = 2;
        };
      };

      lsp = {
        clangd = {
          binaly = {
            path = "clangd";
          };
        };
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
        save = "current";
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
}
