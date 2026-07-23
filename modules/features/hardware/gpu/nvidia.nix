{ shiv, ... }: {
  shiv.hardware.gpu.nvidia = {
    includes = [
      shiv.hardware.diagnostics
    ];
    nixos =
      {
        lib,
        config,
        pkgs,
        ...
      }:
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
          NIXOS_OZONE_WL = lib.mkDefault "1"; # Fixes Chromium/Electron apps (like Discord) crashing on Wayland

          # Solves "libEGL warning: egl: failed to create dri2 screen"
          __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS = "/run/opengl-driver/share/egl/egl_external_platform.d";
        };
      };
  };
}
