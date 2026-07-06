{ ... }: {
  den.aspects.hardware.diagnostics = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        pciutils
        usbutils
        dmidecode
        lshw
        lm_sensors
      ];
    };
  };
}
