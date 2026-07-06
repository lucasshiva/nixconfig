{ den, ... }: {
  den.aspects.hardware.gpu.nvidia = {
    includes = [
      den.aspects.hardware.diagnostics
    ];
    nixos =
      { config, pkgs, ... }:
      {
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };

        services.xserver.videoDrivers = [ "nvidia" ];
        hardware.nvidia = {
          open = true;
          modesetting.enable = true;
          nvidiaSettings = true;
          powerManagement = {
            enable = true;
            finegrained = false;
          };
          package = config.boot.kernelPackages.nvidiaPackages.latest;
        };

        environment.systemPackages = with pkgs; [ nvtopPackages.nvidia ];

        boot.kernelParams = [ "nvidia.NVreg_TemporaryFilePath=/var/tmp" ];

        # Enforce Wayland/EGL environment variables for Nvidia
        environment.variables = {
          LIBVA_DRIVER_NAME = "nvidia";
          GBM_BACKEND = "nvidia-drm";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          NIXOS_OZONE_WL = "1"; # Fixes Chromium/Electron apps (like Discord) crashing on Wayland
        };
      };
  };
}
