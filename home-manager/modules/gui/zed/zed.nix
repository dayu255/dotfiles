{ ... }:
{
  # zed-editor
  programs.zed-editor = {
    enable = true;

    userSettings = {
      vim_mode = true;
      vim = {
        use_system_clipboard = "always";
        toggle_relative_line_numbers = false;
        highlight_on_yank_duration = 150;
      };
      vertical_scroll_margin = 8;
      relative_line_numbers = "enabled";

      cursor_animation.enable = true;

      git = {
        inline-blame = {
          enabeld = true;
          delay_ms = 500;
        };
      };

      # File Tree
      project_panel = {
        dock = "left";
      };

      # Buffer
      buffer_font_family = "HackGen35 Console NF";
      buffer_font_size = 14;
      buffer_line_height = "comfortable";
      buffer_font_features = {
        calt = false;
      };

      hide_mouse = "on_typing";
      format_on_save = "on";

      ui_font_family = "sans-serif";
      ui_font_size = 15;
      disable_ai = true;
      use_system_path_prompts = false;

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
        git_diff = true;
        diagnostics = "all";
        axes = {
          horizontal = true;
          vertical = true;
        };
      };
      minimap = {
        show = "never";
      };

      tabs = {
        git_status = true;
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
          binary = {
            path = "clangd";
          };
        };
      };

      theme = {
        mode = "dark";
        light = "Ayu Light";
        dark = "Kanagawa";
      };
      #theme = "Catppuccin Macchiato";
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
      {
        label = "Build C++ file for debug";
        command = "g++";
        args = [
          "-g"
          "-O0"
          "$ZED_FILE"
          "-o"
          "$ZED_DIRNAME/$ZED_STEM"
        ];
        type = "shell";
      }
    ];

    userDebug = [
      {
        adapter = "lldb";
        label = "C++ (LLDB)";
        mode = "debug";
        program = "$ZED_DIRNAME/$ZED_STEM";
        cwd = "$ZED_DIRNAME";
        request = "launch";
      }
    ];

    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "ctrl-w" = "pane::CloseActiveItem";
          "ctrl-t" = "workspace::NewFile";

          "ctrl-alt-n" = [
            "task::Spawn"
            { task_name = "Run with qrun"; }
          ];
        };
      }
    ];

    extensions = [
      "html"
      "nix"
      "dockerfile"
      "docker-compose"
      "env"
      "ruby"
      "kanagawa-themes"
      "git-firefly"
      "toml"
      "astro"
      "lua"
      "harper"
      "sql"
      "haskell"

      # "catppuccin"
      # "catppuccin-icons"
    ];

    mutableUserSettings = false;
    mutableUserKeymaps = false;
    mutableUserTasks = false;
    mutableUserDebug = false;
  };

  xdg.configFile."zed/themes/".source = ./themes;
}
