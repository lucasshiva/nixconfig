{ ... }:
{
  shiv.desktop.niri.binds = {
    homeManager =
      {
        lib,
        config,
        ...
      }:
      let
        cfg = config.my.niri;
      in
      {
        programs.niri.settings.binds = {
          "Mod+T" = {
            action.spawn = lib.getExe cfg.term;
            hotkey-overlay.title = "Open terminal: ${cfg.term.pname}";
          };
          "Mod+O" = {
            action.toggle-overview = [ ];
            repeat = false;
          };
          "Mod+Tab" = {
            action.toggle-overview = [ ];
            repeat = false;
          };
          "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];
          "Mod+Shift+E".action.quit = [ ];
          "Mod+Q" = {
            action.close-window = [ ];
            repeat = false;
          };
          "Mod+F".action.maximize-column = [ ];
          "Mod+Shift+F".action.fullscreen-window = [ ];
          "Mod+Shift+T".action.toggle-window-floating = [ ];
          "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [ ];
          "Mod+W".action.toggle-column-tabbed-display = [ ];

          # Focus navigation.
          "Mod+Left".action.focus-column-left = [ ];
          "Mod+Down".action.focus-window-down = [ ];
          "Mod+Up".action.focus-window-up = [ ];
          "Mod+Right".action.focus-column-right = [ ];

          # Window movement
          "Mod+Shift+Left".action.move-column-left = [ ];
          "Mod+Shift+Down".action.move-window-down = [ ];
          "Mod+Shift+Up".action.move-window-up = [ ];
          "Mod+Shift+Right".action.move-column-right = [ ];

          # Column navigation
          "Mod+Home".action.focus-column-first = [ ];
          "Mod+End".action.focus-column-last = [ ];
          "Mod+Ctrl+Home".action.focus-column-first = [ ];
          "Mod+Ctrl+End".action.focus-column-last = [ ];

          # Monitor navigation
          "Mod+Alt+Left".action.focus-monitor-left = [ ];
          "Mod+Alt+Down".action.focus-monitor-down = [ ];
          "Mod+Alt+Up".action.focus-monitor-up = [ ];
          "Mod+Alt+Right".action.focus-monitor-right = [ ];

          # Move to monitor
          "Mod+Shift+Alt+Left".action.move-column-to-monitor-left = [ ];
          "Mod+Shift+Alt+Down".action.move-column-to-monitor-down = [ ];
          "Mod+Shift+Alt+Up".action.move-column-to-monitor-up = [ ];
          "Mod+Shift+Alt+Right".action.move-column-to-monitor-right = [ ];

          # Workspace navigation
          "Mod+Page_Down".action.focus-workspace-down = [ ];
          "Mod+Page_Up".action.focus-workspace-up = [ ];
          "Mod+Ctrl+Down".action.move-column-to-workspace-down = [ ];
          "Mod+Ctrl+Up".action.move-column-to-workspace-up = [ ];

          # Move Workspaces
          "Mod+Ctrl+Page_Down".action.move-workspace-down = [ ];
          "Mod+Ctrl+Page_Up".action.move-workspace-up = [ ];

          # Column Management
          "Mod+BracketLeft".action.consume-or-expel-window-left = [ ];
          "Mod+BracketRight".action.consume-or-expel-window-right = [ ];
          "Mod+Period".action.expel-window-from-column = [ ];

          # Sizing
          "Mod+R".action.switch-preset-column-width = [ ];
          "Mod+Shift+R".action.switch-preset-window-height = [ ];
          "Mod+Ctrl+R".action.reset-window-height = [ ];
          "Mod+Ctrl+F".action.expand-column-to-available-width = [ ];
          "Mod+C".action.center-column = [ ];
          "Mod+Ctrl+C".action.center-visible-columns = [ ];
          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";

          # Screenshots
          "XF86Launch1".action.screenshot = [ ];
          "Ctrl+XF86Launch1".action.screenshot-screen = [ ];
          "Alt+XF86Launch1".action.screenshot-window = [ ];
          "Print".action.screenshot = [ ];
          "Ctrl+Print".action.screenshot-screen = [ ];
          "Alt+Print".action.screenshot-window = [ ];

          # System
          "Mod+Escape" = {
            action.toggle-keyboard-shortcuts-inhibit = [ ];
            allow-inhibiting = false;
          };
          "Mod+Shift+P".action.power-off-monitors = [ ];
        };
      };
  };
}
