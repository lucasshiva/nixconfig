{ lib, ... }: {

  shiv.desktop.niri.nixos =
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

      # Disable KDE login manager in favor of Noctalia Greeter.
      services.displayManager.plasma-login-manager.enable = lib.mkForce false;
    };

  shiv.desktop.niri.homeManager =
    {
      pkgs,
      config,
      ...
    }:
    let
      inherit (lib) mkOption types;
      cfg = config.my.niri;
      isNoctaliaEnabled = config.my.noctalia.enable;

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 32;
      };
      noctaliaConfig = ''
        include "noctalia.kdl" optional=true
        include "noctalia-binds.kdl" optional=true
        spawn-at-startup "noctalia"
        window-rule {
            geometry-corner-radius ${builtins.toString cfg.corner-radius}
            clip-to-geometry true
        }
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
      noctaliaBinds = ''
        binds {
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
        }
      '';
      niriConfig = ''
        input {
          keyboard {
            xkb {
              layout "us(altgr-intl)"
              model "pc105"
              options "compose:rwin"
            }
            numlock
          }
        }

        output "DP-2" {
          mode "1920x1080"
          position x=2560 y=0
        }

        output "DP-3" {
          mode "2560x1440"
          position x=0 y=0
          focus-at-startup
        }

        output "HDMI-A-1" {
          position x=2560 y=1080
          scale 1.3
        }

        screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
        prefer-no-csd
        layout {
            gaps ${builtins.toString cfg.gaps}
            focus-ring { width 2; }
            border { off; }
            default-column-width { proportion 0.5; }
            center-focused-column "never"
            always-center-single-column
        }
        cursor {
            xcursor-theme "${cursor.name}"
            xcursor-size ${builtins.toString cursor.size}
        }
        hotkey-overlay { skip-at-startup; }

        binds {
            Alt+Print { screenshot-window; }
            Alt+XF86Launch1 { screenshot-window; }
            Ctrl+Print { screenshot-screen; }
            Ctrl+XF86Launch1 { screenshot-screen; }
            Mod+Alt+Down { focus-monitor-down; }
            Mod+Alt+F { toggle-window-floating; }
            Mod+Alt+Left { focus-monitor-left; }
            Mod+Alt+Right { focus-monitor-right; }
            Mod+Alt+Up { focus-monitor-up; }
            Mod+Alt+V { switch-focus-between-floating-and-tiling; }
            Mod+BracketLeft { consume-or-expel-window-left; }
            Mod+BracketRight { consume-or-expel-window-right; }
            Mod+C { center-column; }
            Mod+Ctrl+C { center-visible-columns; }
            Mod+Ctrl+Down { move-column-to-workspace-down; }
            Mod+Ctrl+End { focus-column-last; }
            Mod+Ctrl+F { expand-column-to-available-width; }
            Mod+Ctrl+Home { focus-column-first; }
            "Mod+Ctrl+Page_Down" { move-workspace-down; }
            "Mod+Ctrl+Page_Up" { move-workspace-up; }
            Mod+Ctrl+R { reset-window-height; }
            Mod+Ctrl+Up { move-column-to-workspace-up; }
            Mod+Down { focus-window-down; }
            Mod+End { focus-column-last; }
            Mod+Equal { set-column-width "+10%"; }
            Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
            Mod+F { maximize-column; }
            Mod+Home { focus-column-first; }
            Mod+Left { focus-column-left; }
            Mod+Minus { set-column-width "-10%"; }
            Mod+O repeat=false { toggle-overview; }
            "Mod+Page_Down" { focus-workspace-down; }
            "Mod+Page_Up" { focus-workspace-up; }
            Mod+Period { expel-window-from-column; }
            Mod+Q repeat=false { close-window; }
            Mod+R { switch-preset-column-width; }
            Mod+Right { focus-column-right; }
            Mod+Shift+Alt+Down { move-column-to-monitor-down; }
            Mod+Shift+Alt+Left { move-column-to-monitor-left; }
            Mod+Shift+Alt+Right { move-column-to-monitor-right; }
            Mod+Shift+Alt+Up { move-column-to-monitor-up; }
            Mod+Shift+Down { move-window-down; }
            Mod+Shift+E { quit; }
            Mod+Shift+Equal { set-window-height "+10%"; }
            Mod+Shift+F { fullscreen-window; }
            Mod+Shift+Left { move-column-left; }
            Mod+Shift+Minus { set-window-height "-10%"; }
            Mod+Shift+P { power-off-monitors; }
            Mod+Shift+R { switch-preset-window-height; }
            Mod+Shift+Right { move-column-right; }
            Mod+Shift+Slash { show-hotkey-overlay; }
            Mod+Shift+Up { move-window-up; }
            Mod+T hotkey-overlay-title="Open terminal: kitty" { spawn "${lib.getExe pkgs.kitty}"; }
            Mod+Tab repeat=false { toggle-overview; }
            Mod+Up { focus-window-up; }
            Mod+W { toggle-column-tabbed-display; }
            Print { screenshot; }
            XF86Launch1 { screenshot; }
          }

          window-rule {
              match app-id="org.kde.haruna"
              match app-id="org.kde.gwenview"
              match app-id="re.sonny.Junction"
              match app-id="qimgv"
              match app-id="mpv"
              match title="Welcome to Android Studio"
              match title="Welcome to Rider"
              match title="Welcome to IntelliJ IDEA"
              match title="Steam Settings"
              open-floating true
          }
          window-rule {
              match app-id="Emulator"
              default-column-width { fixed 410; }
              default-window-height { fixed 912; }
          }
          gestures {
            hot-corners { off; };
          }
      ''
      + lib.optionalString isNoctaliaEnabled noctaliaConfig;
    in
    {
      options.my.niri = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        gaps = mkOption {
          type = types.int;
          default = 12;
        };
        corner-radius = mkOption {
          type = types.float;
          default = 12.0;
        };
      };

      config = lib.mkIf cfg.enable {
        home.file.".config/niri/config.kdl".text = niriConfig;
        home.file.".config/niri/noctalia-binds.kdl".text = noctaliaBinds;
        home.packages = with pkgs; [
          xwayland-satellite

          # GTK Theming. Select `adw-gtk3`.
          nwg-look
          adw-gtk3

          nautilus # For GNOME portal.

          kdePackages.knewstuff # Open color section in KDE settings outside of KDE.
          kdePackages.ksvg # Open plasma style section in KDE settings outside of KDE.
          kdePackages.kdeclarative # Open plasma style section in KDE settings outside of KDE.
        ];
        home.sessionVariables = {
          # Fix empty default application menu in Dolphin.
          XDG_MENU_PREFIX = "plasma-";

          # QT config
          QT_AUTO_SCREEN_SCALE_FACTOR = "1";
          QT_ENABLE_HIGHDPI_SCALING = "1";
          QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
          QT_QPA_PLATFORM = "wayland;xcb"; # Prefer Wayland

          # Not sure what these two do
          GTK_DECORATION_LAYOUT = "";
          SDL_VIDEODRIVER = "wayland";

          _JAVA_AWT_WM_NONREPARENTING = "1"; # Java (Swing/AWT)
          MOZ_ENABLE_WAYLAND = "1"; # Mozilla (Firefox, Thunderbird)

          # Electron apps default to Wayland without extra flags.
          NIXOS_OZONE_WL = lib.mkDefault "1";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
        };

        # Manage portals.
        xdg.portal.enable = true;

        # Just in case the KDE portal fails or something. Requires Nautilus.
        xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
        xdg.portal.config.niri = {
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

        home.pointerCursor = {
          enable = true;
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
      };
    };
}
