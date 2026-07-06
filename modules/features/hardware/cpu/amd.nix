{ ... }: {
  den.aspects.hardware.cpu.amd = {
    nixos = { config, ... }: {
      boot.kernelParams = [ "amd_pstate=active" ];
      boot.blacklistedKernelModules = [ "k10temp" ];
      boot.extraModulePackages = [ config.boot.kernelPackages.zenpower ];
      boot.kernelModules = [ "zenpower" ];
    };
  };
}
