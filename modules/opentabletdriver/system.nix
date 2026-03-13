{ config, lib, ... }:

let
  cfg = config.my.opentabletdriver;
in
{
  options.my.opentabletdriver.enable = lib.mkEnableOption "Tablet support";

  config = lib.mkIf cfg.enable {
    hardware.opentabletdriver.enable = true;
    hardware.uinput.enable = true;
    boot.kernelModules = [ "uinput" ];
  };
}
