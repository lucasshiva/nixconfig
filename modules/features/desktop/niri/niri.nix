/*
  Niri is a scrollable-tiling Wayland compositor. Some alternatives are:
  - Hyprland
  - MangoWC

  I always have KDE on my system, so I don't need to configure Niri extensively to make it work
  with Qt/KDE apps - KDE does most of the work for me. Because of that, this module includes the KDE
  module by default.

  We also use the KDE portal, but GNOME portal is included as a fallback, so Nautilus is a required
  dependency together with KDE.

  In standalone systems, we have to install KDE, Niri, and Nautilus.
*/

{
  shiv,
  inputs,
  lib,
  ...
}:
{
  shiv.desktop.niri = {
    includes = [
      shiv.desktop.kde
      shiv.apps.kitty
      shiv.desktop.niri.binds
    ];

    nixos =
      { pkgs, config, ... }:
      {
        # NixOS otherwise injects a stripped PATH via Environment= on the niri.service
        # unit which shadows the imported user-manager PATH. Disabling the default
        # lets niri inherit the full PATH set up by niri-session.
        #
        # Enabling `programs.niri` from NixOS already sets this to false.
        systemd.user.services.niri.enableDefaultPath = false;

        # Enabled if for some reason KDE is disabled.
        services.gnome.gnome-keyring.enable = !config.services.desktopManager.plasma6.enable;

        # Ensure polkit is enabled, otherwise it won't work.
        # This is also required by NetworkManager.
        security.polkit.enable = true;

        # Enabling Niri manually for now.
        environment.systemPackages = [ pkgs.niri ];
        systemd.packages = [ pkgs.niri ];

        # Required for gnome portal to work. We don't need Nautilus as a normal package.
        services.dbus.packages = [ pkgs.nautilus ];
      };

    homeManager =
      { pkgs, config, ... }:
      let
        cfg = config.my.niri;
        inherit (lib) mkOption types;
        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 32;
        };
      in
      {
        imports = [
          inputs.niri.homeModules.niri # Niri flake
        ];

        options.my.niri = {
          term = mkOption {
            type = types.package;
            description = "Default terminal for Niri";
            default = pkgs.kitty;
          };
          layout = {
            gaps = mkOption {
              type = types.int;
              default = 12;
            };
          };
          windows = {
            corner-radius = mkOption {
              type = types.float;
              default = 12.0;
            };
          };
        };

        config = {
          home.packages = with pkgs; [
            xwayland-satellite
            # GTK theming. Select `adw-gtk3` and apply.
            # Keep GTK 4 unchecked in Noctalia's templates as some apps have issues with it.
            # See https://docs.noctalia.dev/v5/templates/official/gtk-qt/
            nwg-look
            adw-gtk3

            kdePackages.knewstuff # Open color section in KDE settings outside of KDE.
            kdePackages.ksvg # Open plasma style section in KDE settings outside of KDE.
            kdePackages.kdeclarative # Open plasma style section in KDE settings outside of KDE.
          ];

          xdg.portal = {
            enable = true;

            # NOTE: `configPackages` is ignored when `xdg.portal.config.niri` is defined.
            config.niri = {
              default = [
                "kde"
                "gnome"
                "gtk"
              ];
              "org.freedesktop.impl.portal.Settings" = "kde;gnome;gtk";
              "org.freedesktop.impl.portal.Access" = "kde;gnome;gtk";
              "org.freedesktop.impl.portal.FileChooser" = "kde;gnome;gtk";
              "org.freedesktop.impl.portal.Notification" = "kde;gnome;gtk";
            };

            extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
          };

          home.sessionVariables = {
            # REQUIRED: make sure portal uses KDE Qt platform theme
            # QT_QPA_PLATFORMTHEME = "kde";
            # QT_QPA_PLATFORMTHEME_QT6 = "kde";

            # REQUIRED: helps fixing Dolphin default applications issue
            XDG_MENU_PREFIX = "plasma-";

            QT_AUTO_SCREEN_SCALE_FACTOR = "1";
            QT_ENABLE_HIGHDPI_SCALING = "1";
            QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";

            # Qt: prefer Wayland
            QT_QPA_PLATFORM = "wayland;xcb";

            GTK_DECORATION_LAYOUT = "";

            # SDL
            SDL_VIDEODRIVER = "wayland";

            # Java (Swing/AWT)
            _JAVA_AWT_WM_NONREPARENTING = "1";

            # Mozilla (Firefox, Thunderbird)
            MOZ_ENABLE_WAYLAND = "1";

            # Electron apps default to Wayland without extra flags.
            NIXOS_OZONE_WL = lib.mkDefault "1";
            ELECTRON_OZONE_PLATFORM_HINT = "auto";
          };

          home.pointerCursor = {
            package = cursor.package;
            name = cursor.name;
            size = cursor.size;

            gtk.enable = true;
            x11.enable = true;
          };

          gtk.enable = true;
          qt = {
            enable = true;
            platformTheme.name = "kde";
            style.name = "breeze";
          };

          programs.niri = {
            enable = true;
            package = pkgs.niri; # from nixpkgs to benefit from binary cache
            settings = {
              spawn-at-startup = [
                # Niri (or Noctalia-Greeter) isn't setting XDG_CURRENT_DESKTOP on startup, so we do
                # it ourselves to avoid issues with some apps (e.g. zed) not opening.
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

              cursor = {
                theme = cursor.name;
                size = cursor.size;
              };

              input.keyboard.xkb.options = "compose:rwin";
              input.keyboard.numlock = true;
              hotkey-overlay.skip-at-startup = true;
              gestures.hot-corners.enable = false;
              prefer-no-csd = true;

              outputs = {
                "DP-3" = {
                  mode.width = 2560;
                  mode.height = 1440;
                  position.x = 0;
                  position.y = 0;
                  focus-at-startup = true;
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
                gaps = cfg.layout.gaps;
                default-column-width = {
                  proportion = 0.5;
                };
                always-center-single-column = true;
                border.enable = false; # Border takes away space from windows, so we use focus-ring instead.
                focus-ring.enable = true;
                focus-ring.width = 2;
                shadow.enable = true;
              };

              window-rules = [
                {
                  geometry-corner-radius =
                    let
                      r = cfg.windows.corner-radius;
                    in
                    {
                      top-left = r;
                      top-right = r;
                      bottom-left = r;
                      bottom-right = r;
                    };
                  clip-to-geometry = true;
                }

                {
                  matches = [
                    { app-id = "org.kde.haruna"; }
                    { app-id = "org.kde.gwenview"; }
                    { app-id = "qimgv"; }
                    { app-id = "mpv"; }
                    { title = "Steam Settings"; }
                  ];
                  open-floating = true;
                }
              ];
            };
          };
        };
      };
  };
}
