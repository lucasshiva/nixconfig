{
  shiv,
  inputs,
  lib,
  ...
}:
{
  shiv.desktop.niri = {
    includes = [ shiv.desktop.niri.binds ];

    nixos =
      { ... }:
      {
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };

        # NixOS otherwise injects a stripped PATH via Environment= on the niri.service
        # unit which shadows the imported user-manager PATH. Disabling the default
        # lets niri inherit the full PATH set up by niri-session.
        #
        # Enabling `programs.niri` from NixOS already sets this to false.
        systemd.user.services.niri.enableDefaultPath = false;

        # I'm not sure if this conflicts with kwallet if KDE is installed.
        services.gnome.gnome-keyring.enable = true;

        security.polkit.enable = true;

        # If we're using `xdg-desktop-portal-gnome`, it will attempt to use Nautilus as the file picker,
        # which will fail if Nautilus is not installed.
        #
        # To work around this problem, you can force usage of the gtk or kde portals for file picker instead.
        xdg.portal = {
          enable = true;
          config.niri = {
            default = [
              "gnome"
              "gtk"
            ];
            "org.freedesktop.impl.portal.Access" = "gtk";
            "org.freedesktop.impl.portal.FileChooser" = "gtk";
            "org.freedesktop.impl.portal.Notification" = "gtk";
            "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
          };
        };

        # Enabling this sets the xdg config portal. I'm not even sure if we do need to enable it.
        # I only did so because I wanted Niri available as an option in the greeter.
        # But maybe we can simply add it to `environment.systemPackages` or `systemd.packages`.
        # Reference: https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/programs/wayland/niri.nix
        programs.niri.enable = true;
      };

    homeManager =
      { pkgs, ... }:
      {
        imports = [
          inputs.niri.homeModules.niri
        ];

        options.my.niri = {
          term = lib.mkOption {
            type = lib.types.package;
            description = "Default terminal for Niri";
            default = pkgs.kitty;
          };
        };

        config = {
          # `programs.niri` comes from niri-flake.
          home.packages = with pkgs; [
            xwayland-satellite
            qt6Packages.qt6ct # For qt 6 theming.
          ];

          home.sessionVariables = {
            # Qt
            QT_QPA_PLATFORMTHEME = "qt6ct";

            # GTK: prefer Wayland
            GDK_BACKEND = "wayland,x11";

            # Qt: prefer Wayland
            QT_QPA_PLATFORM = "wayland;xcb";

            # SDL
            SDL_VIDEODRIVER = "wayland";

            # Java (Swing/AWT)
            _JAVA_AWT_WM_NONREPARENTING = "1";

            # Mozilla (Firefox, Thunderbird)
            MOZ_ENABLE_WAYLAND = "1";

            # Electron apps default to Wayland without extra flags.
            NIXOS_OZONE_WL = lib.mkDefault "1";
          };

          home.pointerCursor = {
            gtk.enable = true;
            x11.enable = true;

            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Classic";
            size = 30;
          };

          gtk.enable = true;
          qt.enable = true;

          programs.niri = {
            enable = true;
            package = pkgs.niri; # from nixpkgs to benefit from binary cache
            settings = {
              input.keyboard.xkb.options = "compose:rwin";
              input.keyboard.numlock = true;
              hotkey-overlay.skip-at-startup = true;

              outputs = {
                "DP-3" = {
                  mode.width = 2560;
                  mode.height = 1440;
                  position.x = 0;
                  position.y = 0;
                };
                "DP-2" = {
                  mode.width = 1920;
                  mode.height = 1080;
                  position.x = 2560; # Right to DP-3.
                  position.y = 0;
                };
                "HDMI-A-1" = {
                  scale = 1.3;
                  position.x = 2560; # Right to DP-3.
                  position.y = 1080; # Below DP-2
                };
              };

              layout = {
                gaps = 16;
                default-column-width = {
                  proportion = 0.5;
                };
                always-center-single-column = true;
                border.width = 2;
                focus-ring.width = 2;
              };

              gestures.hot-corners.enable = false;

              window-rules = [
                {
                  geometry-corner-radius =
                    let
                      r = 16.0;
                    in
                    {
                      top-left = r;
                      top-right = r;
                      bottom-left = r;
                      bottom-right = r;
                    };
                  clip-to-geometry = true;
                  tiled-state = true;
                  draw-border-with-background = false;
                }
              ];
            };
          };
        };
      };
  };
}
