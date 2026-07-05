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
