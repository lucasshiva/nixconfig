{ ... }: {
  shiv.apps.zed = {
    homeManager = { pkgs, ... }: {
      programs.zed-editor = {
        enable = true;
        # Might be useful
        # package = pkgs.zed-editor-fhs;
        defaultEditor = true;
        extensions = [
          "nix"
          "material-icon-theme"
          "catppuccin"
          "git-firefly"
          "toml"
        ];
        userSettings = {
          git_panel = {
            dock = "left";
            file_icons = true;
            tree_view = true;
          };
          project_panel = {
            dock = "left";
            auto_reveal_entries = false;
            git_status_indicator = true;
          };
          icon_theme = "Material Icon Theme";
          ui_font_size = 16;
          buffer_font_size = 16;
          mouse_wheel_zoom = true;
          wrap_guides = [ 100 ];
          show_wrap_guides = true;
          colorize_brackets = true;
          indent_guides = {
            line_width = 1;
            active_line_width = 3;
            background_coloring = "disabled";
            coloring = "indent_aware";
          };
          "preferred_line_length" = 100;
          theme = {
            mode = "dark";
            light = "Catppuccin Latte - No Italics";
            dark = "Catppuccin Mocha - No Italics";
          };
        };
      };
    };
  };
}
