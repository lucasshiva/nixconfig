{ shiv, ... }: {
  shiv.hardware.diagnostics = {
    includes = [ shiv.cli.btop ];

    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        pciutils
        usbutils
        dmidecode
        lshw
        lm_sensors
        mesa-demos
      ];
    };
  };
}
