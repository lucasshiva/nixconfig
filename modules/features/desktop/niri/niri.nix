{
  den,
  inputs,
  lib,
  ...
}:
{
  den.aspects.desktop.niri = {
    includes = [ den.aspects.desktop.niri.binds ];
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
        systemd.user.services.niri.enableDefaultPath = false;

        services.gnome.gnome-keyring.enable = false; # Always nice to have.
        #security.polkit.enable = true; # Maybe we don't need this since DMS has a polkit?

        # If we're using `xdg-desktop-portal-gnome`, it will attempt to use Nautilus as the file picker,
        # which will fail if Nautilus is not installed.
        #
        # To work around this problem, you can force usage of the gtk or kde portals for file picker instead.
        xdg.portal.config.niri = {
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ]; # or "kde"
        };

        # Replace with Dank Greeter.
        # I think Noctalia also has a greeter, but only for v5. Worth checking it out.
        # services.greetd = {
        #   enable = true;
        #   settings = {
        #     default_session = {
        #       command = "${config.programs.niri.package}/bin/niri-session";
        #       user = username;
        #     };
        #   };
        # };

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
          home.packages = with pkgs; [ xwayland-satellite ];
          programs.niri = {
            enable = true;
            package = pkgs.niri; # from nixpkgs to benefit from binary cache
            settings = {
              input.keyboard.xkb.options = "compose:rwin";

              layout = {
                gaps = 4;
                default-column-width = {
                  proportion = 0.5;
                };
                always-center-single-column = true;
                border.width = 2;
                focus-ring.width = 2;
              };

              window-rules = [
                {
                  geometry-corner-radius =
                    let
                      r = 12.0;
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
