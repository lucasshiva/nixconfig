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
          };
        };
      };

    homeManager =
      { pkgs, config, ... }:
      let
        inherit (config.lib.niri.actions) spawn;
        wallpapers = "/mnt/data/Media/Pictures/Wallpapers";
        noc = spawn "noctalia" "msg";
      in
      {
        imports = [ inputs.noctalia.homeModules.default ];

        programs.noctalia = {
          enable = true;
          settings = {
            theme = {
              mode = "dark";
              source = "wallpaper";
              builtin = "Catppuccin";
              wallpaper_scheme = "m3-content";
              templates.builtin_ids = [
                "niri"
                "gtk3"
                "gtk4"
                "qt"
              ];
            };

            wallpaper = {
              enabled = true;
              directory = wallpapers;
              transition_duration = 1200; # default is 1500
              transition_on_startup = true;
              automation = {
                enabled = true;
                interval_seconds = 600;
              };
              default = "${wallpapers}/wallhaven-1pq7zg.jpg";
            };

            backdrop.enabled = true;
            audio.enable_overdrive = true;
            location.auto_locate = true;

            bar.default = {
              border = "on_surface";
              border_width = 1.0;
              margin_ends = 0;
            };

            dock = {
              enabled = true;
              active_monitor_only = true;
              auto_hide = true;
              reserve_space = false;
              show_dots = true;
            };

            shell = {
              polkit_agent = true;
              greeter_sync.auto_sync = false;
            };

            nightlight = {
              enabled = true;
              temperature_day = 4500;
              temperature_night = 3200;
            };
          };
        };

        programs.niri.settings = lib.mkIf config.programs.niri.enable {
          spawn-at-startup = [
            { command = [ "noctalia" ]; }
            {
              command = [
                "dbus-update-activation-environment"
                "--systemd"
                "DISPLAY"
                "WAYLAND_DISPLAY"
                "XDG_CURRENT_DESKTOP=niri"
              ];
            }
            {
              command = [
                "systemctl"
                "--user"
                "import-environment"
                "DISPLAY"
                "WAYLAND_DISPLAY"
                "XDG_CURRENT_DESKTOP"
              ];
            }
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
              action = noc "media" "next";
            };
            "XF86AudioNext" = {
              action = noc "media" "previous";
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
