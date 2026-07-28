{ inputs, lib, ... }: {
  shiv.desktop.noctalia = {

    nixos =
      { pkgs, ... }:
      {
        imports = [
          inputs.noctalia-greeter.nixosModules.default
          inputs.noctalia.nixosModules.default
        ];

        programs.noctalia-greeter = {
          enable = true;
          settings = {
            keyboard = {
              layout = "us";
            };
            cursor = {
              theme = "Bibata-Modern-Ice";
              size = 32;
              path = "${pkgs.bibata-cursors}/share/icons";
            };
          };
        };

        programs.noctalia = {
          enable = true;
          recommendedServices.enable = true;
        };
      };

    homeManager =
      { config, ... }:
      let
        inherit (lib) mkOption types;
        cfg = config.my.noctalia;
        niri = config.my.niri;
        wallpapers = "/mnt/ntfs/Media/Pictures/Wallpapers";
        niriConfig = ''
          include "noctalia.kdl" optional=true
          spawn-at-startup "noctalia"

          window-rule {
              match app-id="dev.noctalia.Noctalia"
              open-floating true
          }
          layer-rule {
              match namespace="^noctalia-backdrop"
              place-within-backdrop true
          }
          debug { honor-xdg-activation-with-invalid-serial; }
        '';
        niriBinds = ''
            Mod+Y { spawn "noctalia" "msg" "panel-toggle" "wallpaper"; }
            Mod+Alt+Y { spawn "noctalia" "msg" "wallpaper-random"; }
            Mod+Ctrl+Y { spawn "noctalia" "msg" "wallpaper-previous"; }
            Mod+Shift+Y { spawn "noctalia" "msg" "wallpaper-next"; }

            Mod+Comma { spawn "noctalia" "msg" "settings-toggle"; }
            Mod+L { spawn "noctalia" "msg" "session" "lock"; }
            Mod+S { spawn "noctalia" "msg" "panel-toggle" "control-center"; }
            Mod+Space hotkey-overlay-title="Application launcher" { spawn "noctalia" "msg" "panel-toggle" "launcher"; }
            Mod+V { spawn "noctalia" "msg" "panel-toggle" "clipboard"; }
            Mod+X { spawn "noctalia" "msg" "panel-toggle" "session"; }

            XF86AudioLowerVolume { spawn "noctalia" "msg" "volume-down"; }
            XF86AudioMicMute { spawn "noctalia" "msg" "mic-mute"; }
            XF86AudioMute { spawn "noctalia" "msg" "volume-mute"; }
            XF86AudioNext { spawn "noctalia" "msg" "media" "next"; }
            XF86AudioPlay { spawn "noctalia" "msg" "media" "toggle"; }
            XF86AudioPrev { spawn "noctalia" "msg" "media" "previous"; }
            XF86AudioRaiseVolume { spawn "noctalia" "msg" "volume-up"; }
            XF86MonBrightnessDown { spawn "noctalia" "msg" "brightness-down"; }
            XF86MonBrightnessUp { spawn "noctalia" "msg" "brightness-up"; }
        '';
      in
      {
        options.my.noctalia = {
          enable = mkOption {
            type = types.bool;
            description = "Enable Noctalia";
            default = true;
          };
        };

        config = lib.mkIf cfg.enable {
          my.niri.extraBinds = lib.mkIf niri.enable niriBinds;
          my.niri.extraConfig = lib.mkIf niri.enable niriConfig;

          home.file.".config/noctalia/config.toml".text = ''
            [audio]
            enable_overdrive = true

            [backdrop]
            blur_intensity = 0.3
            enabled = true

            [bar.default]
            background_opacity = 0.95
            border = "primary"
            border_width = 1.0
            capsule = true
            capsule_fill = "on_secondary"
            capsule_opacity = 1.0
            capsule_padding = 10.0
            capsule_radius = "auto"
            capsule_thickness = 0.7
            center = ["clock", "weather"]
            end = ["media", "audio_visualizer", "tray", "notifications", "clipboard", "network", "bluetooth", "volume", "brightness", "battery", "control-center", "session"]
            font_family = "DejaVu Sans Mono"
            icon_color = "primary"
            margin_edge = 8
            margin_ends = ${builtins.toString niri.gaps}
            margin_opposite_edge = 4
            scale = 1
            start = ["launcher", "workspaces", "active_window", "cpu", "ram"]
            thickness = 42

            [dock]
            active_monitor_only = true
            auto_hide = true
            background_opacity = 0.8
            enabled = false
            margin_edge = 8
            margin_ends = 8
            reserve_space = false
            show_dots = true

            [idle]
            behavior_order = ["lock", "screen-off", "lock-and-suspend"]

            [idle.behavior.lock]
            action = "lock"
            enabled = true
            timeout = 450.0

            [idle.behavior.lock-and-suspend]
            action = "lock_and_suspend"
            enabled = true
            timeout = 900.0

            [idle.behavior.screen-off]
            action = "screen_off"
            enabled = true
            timeout = 600.0

            [location]
            auto_locate = true

            [lockscreen.widgets]
            enabled = true
            schema_version = 2
            widget_order = ["lockscreen-login-box@DP-3", "lockscreen-login-box@DP-2", "lockscreen-login-box@HDMI-A-1", "lockscreen-widget-0000000000000001", "lockscreen-widget-0000000000000002"]

            [lockscreen.widgets.widget.lockscreen-widget-0000000000000001]
            box_height = 0.0
            box_width = 0.0
            cx = 1280.0
            cy = 611.5
            output = "DP-3"
            rotation = 0.0
            type = "clock"

            [lockscreen.widgets.widget.lockscreen-widget-0000000000000002]
            box_height = 128.0
            box_width = 320.0
            cx = 1277.0
            cy = 784.0
            output = "DP-3"
            rotation = 0.0
            type = "media_player"

            [nightlight]
            enabled = true
            temperature_day = 4200
            temperature_night = 3000

            [osd.kinds]
            lock_keys = false
            media = false

            [shell]
            app_icon_color = "on_surface_variant"
            clipboard_history_max_entries = 1000
            polkit_agent = true

            [shell.greeter_sync]
            auto_sync = false

            [[shell.session.actions]]
            action = "lock"
            countdown_seconds = 3.0
            enabled = true
            shortcut = "1"
            variant = "default"

            [[shell.session.actions]]
            action = "lock_and_suspend"
            countdown_seconds = 3.0
            enabled = true
            shortcut = "2"
            variant = "default"

            [[shell.session.actions]]
            action = "logout"
            countdown_seconds = 5.0
            enabled = true
            shortcut = "3"
            variant = "default"

            [[shell.session.actions]]
            action = "reboot"
            countdown_seconds = 5.0
            enabled = true
            shortcut = "4"
            variant = "default"

            [[shell.session.actions]]
            action = "shutdown"
            countdown_seconds = 5.0
            enabled = true
            shortcut = "5"
            variant = "destructive"

            [system.monitor]
            cpu_poll_seconds = 2
            gpu_poll_seconds = 5
            memory_poll_seconds = 2

            [theme]
            builtin = "Catppuccin"
            mode = "dark"
            source = "wallpaper"
            wallpaper_scheme = "m3-tonal-spot"

            [theme.templates]
            builtin_ids = ["niri", "gtk3", "kcolorscheme"]

            [wallpaper]
            default = "${wallpapers}/wallhaven-1pq7zg.jpg"
            directory = "${wallpapers}"
            enabled = true
            transition_duration = 1500
            transition_on_startup = true

            [wallpaper.automation]
            enabled = true
            interval_seconds = 600

            [widget.active_window]
            show_empty_label = false

            [widget.clock]
            format = "{:%A, %H:%M}"
            tooltip_format = "{:%A, %d de %B, %H:%M}"

            [widget.media]
            art_size = 32
            max_length = 300
            title_scroll = "on_hover"

            [widget.weather]
            show_condition = false
          '';
        };
      };

  };
}
