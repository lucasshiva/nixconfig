{ inputs, lib, ... }: {
  shiv.desktop.noctalia = {

    nixos =
      { pkgs, ... }:
      {
        imports = [ inputs.noctalia-greeter.nixosModules.default ];

        # Disable Niri Flake polkit - Noctalia has its own.
        systemd.user.services.niri-flake-polkit.enable = false;

        programs.noctalia-greeter = {
          enable = true;
          settings = {
            output = {
              name = "DP-3";
            };
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
      };

    homeManager =
      { pkgs, config, ... }:
      let
        niri = config.my.niri;
        inherit (config.lib.niri.actions) spawn;
        wallpapers = "/mnt/data/Media/Pictures/Wallpapers";
        noc = spawn "noctalia" "msg";
      in
      {
        imports = [
          inputs.noctalia.homeModules.default
          inputs.pam-shim.homeModules.default
        ];

        pamShim.enable = true;

        programs.noctalia = {
          enable = true;
          # Authentication wasn't working on CachyOS because PAM is broken on non-NixOS distros
          # See https://github.com/nix-community/home-manager/issues/7027
          package =
            config.lib.pamShim.replacePam
              inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
          settings = {
            audio.enable_overdrive = true;

            backdrop = {
              enabled = true;
              blur_intensity = 0.3;
            };

            bar.default = {
              background_opacity = 0.95;
              border = "primary";
              border_width = 1.0;
              capsule = true;
              capsule_fill = "on_secondary";
              capsule_opacity = 1.0;
              capsule_padding = 10.0;
              capsule_radius = "auto";
              capsule_thickness = 0.7;
              center = [
                "clock"
                "weather"
              ];
              end = [
                "media"
                "audio_visualizer"
                "tray"
                "notifications"
                "clipboard"
                "network"
                "bluetooth"
                "volume"
                "brightness"
                "battery"
                "control-center"
                "session"
              ];
              font_family = "DejaVu Sans Mono";
              icon_color = "primary";
              margin_edge = 8;
              margin_ends = niri.layout.gaps; # Ensure the bar is the same width as the windows.
              margin_opposite_edge = 4;
              scale = 1;
              start = [
                "launcher"
                "workspaces"
                "active_window"
                "cpu"
                "ram"
              ];
              thickness = 42;
            };

            dock = {
              active_monitor_only = true;
              auto_hide = true;
              background_opacity = 0.8;
              enabled = false; # I don't really use it.
              margin_edge = 8;
              margin_ends = 8;
              reserve_space = false;
              show_dots = true;
            };

            hooks = {
              # Reload theme in KDE apps. Sadly, the CLI lacks a flag to force update an already
              # selected theme.
              colors_changed = ''
                plasma-apply-colorscheme BreezeDark
                plasma-apply-colorscheme noctalia
              '';
            };

            idle = {
              behavior_order = [
                "lock"
                "screen-off"
                "lock-and-suspend"
              ];
              behavior.lock = {
                action = "lock";
                enabled = true;
                timeout = 300.0;
              };
              behavior.lock-and-suspend = {
                action = "lock_and_suspend";
                enabled = true;
                timeout = 900.0;
              };
              behavior.screen-off = {
                action = "screen_off";
                enabled = true;
                timeout = 600.0;
              };
            };

            location.auto_locate = true;

            lockscreen.widgets = {
              enabled = true;
              schema_version = 2;
              widget_order = [
                "lockscreen-login-box@DP-3"
                "lockscreen-login-box@DP-2"
                "lockscreen-login-box@HDMI-A-1"
                "lockscreen-widget-0000000000000001"
                "lockscreen-widget-0000000000000002"
              ];
              widget.lockscreen-widget-0000000000000001 = {
                box_height = 0.0;
                box_width = 0.0;
                cx = 1280.0;
                cy = 611.5;
                output = "DP-3";
                rotation = 0.0;
                type = "clock";
              };
              widget.lockscreen-widget-0000000000000002 = {
                box_height = 128.0;
                box_width = 320.0;
                cx = 1277.0;
                cy = 784.0;
                output = "DP-3";
                rotation = 0.0;
                type = "media_player";
              };
            };

            nightlight = {
              enabled = true;
              temperature_day = 4500;
              temperature_night = 3200;
            };

            osd.kinds = {
              media = false;
              lock_keys = false;
            };

            shell = {
              app_icon_color = "on_surface_variant";
              clipboard_history_max_entries = 1000;
              polkit_agent = true;
              greeter_sync.auto_sync = false;

              session.actions = [
                {
                  action = "lock";
                  countdown_seconds = 3.0;
                  enabled = true;
                  shortcut = "1";
                  variant = "default";
                }
                {
                  action = "lock_and_suspend";
                  countdown_seconds = 3.0;
                  enabled = true;
                  shortcut = "2";
                  variant = "default";
                }
                {
                  action = "logout";
                  countdown_seconds = 5.0;
                  enabled = true;
                  shortcut = "3";
                  variant = "default";
                }
                {
                  action = "reboot";
                  countdown_seconds = 5.0;
                  enabled = true;
                  shortcut = "4";
                  variant = "default";
                }
                {
                  action = "shutdown";
                  countdown_seconds = 5.0;
                  enabled = true;
                  shortcut = "5";
                  variant = "destructive";
                }
              ];
            };

            system.monitor = {
              cpu_poll_seconds = 3;
              gpu_poll_seconds = 5;
              memory_poll_seconds = 3;
            };

            theme = {
              mode = "dark";
              source = "wallpaper"; # I occasionally switch to `builtin` in Noctalia Settings.
              builtin = "Catppuccin";
              wallpaper_scheme = "m3-content";
              templates.builtin_ids = [
                "niri"
                "gtk3"
                "kcolorscheme"
              ];
            };

            wallpaper = {
              enabled = true;
              directory = wallpapers;
              transition_duration = 1500; # default is 1500
              transition_on_startup = true;
              automation = {
                enabled = true;
                interval_seconds = 600;
              };
              default = "${wallpapers}/wallhaven-1pq7zg.jpg";
            };

            widget = {
              active_window.show_empty_label = false;
              clock = {
                format = "{:%A, %H:%M}";
                tooltip_format = "{:%A, %d de %B, %H:%M}";
              };
              media = {
                art_size = 32;
                max_length = 300;
                title_scroll = "on_hover";
              };
              weather = {
                show_condition = false;
              };
            };

          };
        };

        programs.niri.settings = lib.mkIf config.programs.niri.enable {
          spawn-at-startup = [
            { command = [ "noctalia" ]; }
          ];

          debug = {
            honor-xdg-activation-with-invalid-serial = [ ];
          };

          includes = [
            {
              path = "noctalia.kdl";
              optional = true;
            }
          ];

          window-rules = [
            {
              matches = [ { app-id = "dev.noctalia.Noctalia"; } ];
              open-floating = true;
            }
          ];

          layer-rules = [
            {
              matches = [ { namespace = "^noctalia-backdrop"; } ];
              place-within-backdrop = true;
            }
          ];

          binds = {
            "Mod+Space" = {
              action = noc "panel-toggle" "launcher";
              hotkey-overlay.title = "Application launcher";
            };
            "Mod+S" = {
              action = noc "panel-toggle" "control-center";
            };
            "Mod+Comma" = {
              action = noc "settings-toggle";
            };
            "Mod+Y" = {
              action = noc "panel-toggle" "wallpaper";
            };
            "Mod+Shift+Y" = {
              action = noc "wallpaper-next";
            };
            "Mod+Ctrl+Y" = {
              action = noc "wallpaper-previous";
            };
            "Mod+Alt+Y" = {
              action = noc "wallpaper-random";
            };
            "Mod+V" = {
              action = noc "panel-toggle" "clipboard";
            };
            "Mod+X" = {
              action = noc "panel-toggle" "session";
            };
            "Mod+L" = {
              action = noc "session" "lock";
            };
            "XF86AudioRaiseVolume" = {
              action = noc "volume-up";
            };
            "XF86AudioLowerVolume" = {
              action = noc "volume-down";
            };
            "XF86AudioMute" = {
              action = noc "volume-mute";
            };
            "XF86AudioMicMute" = {
              action = noc "mic-mute";
            };
            "XF86AudioPlay" = {
              action = noc "media" "toggle";
            };
            "XF86AudioPrev" = {
              action = noc "media" "previous";
            };
            "XF86AudioNext" = {
              action = noc "media" "next";
            };
            "XF86MonBrightnessUp" = {
              action = noc "brightness-up";
            };
            "XF86MonBrightnessDown" = {
              action = noc "brightness-down";
            };
          };
        };
      };
  };
}
