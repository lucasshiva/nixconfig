{ ... }: {
  den.aspects.hardware.pc.ssd = {
    nixos = { pkgs, ... }: {
      services.fstrim.enable = true;
      environment.systemPackages = with pkgs; [
        smartmontools
        nvme-cli
      ];
    };
  };
}
