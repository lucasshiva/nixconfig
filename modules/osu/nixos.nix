{ config, lib, ... }:

let
  cfg = config.my.osu;
in
{
  imports = [
    ./common.nix
  ];

  config = lib.mkIf cfg.enable {

    # If osu wants tablet, enable it by default
    my.opentabletdriver.enable = lib.mkDefault cfg.enableTablet;
  };
}
