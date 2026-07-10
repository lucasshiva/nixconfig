# This aspect is a mix of two versions. One uses the new driver (ntfs), the other uses the legacy
# driver (ntfs-3g). Maybe we could split each version into their own modules, letting us choose
# between them without commenting/uncommenting a bunch of code.
#
# Additional, we could also move the mount of any additional drivers to host config instead of
# leaving it in hardware config. Then, we could the host to choose a driver so that we could
# automatically mount filesystems using the chosen one.
#
# I won't be doing any of this for now because at the moment I don't really need NTFS anymore.
{ lib, ... }: {
  shiv.filesystem.ntfs = {
    nixos = { pkgs, ... }: {
      # It seems like we don't need to enable the "ntfs" module for the new driver.
      # Or maybe it is enabled by default.
      # boot.kernelModules = [ "ntfs" ];

      # Ensure we're not adding `ntfs-3g` by enabling "ntfs";
      boot.supportedFilesystems = [
        "btrfs"
        "ext4"
        "ntfs" # This fine because I am now using ext4 for the shared drive.
      ];

      # Disable older ntfs modules
      # boot.blacklistedKernelModules = [
      #   "ntfs3" # fast but always buggy
      #   "ntfs-3g" # slow but super reliable
      # ];

      # Userspace utilities for the new ntfs driver. Not sure if this is useful for the old drivers.
      environment.systemPackages = [ pkgs.ntfsprogs-plus ];

      # Ensures Dolphin (and maybe other file managers) auto mounts NTFS drives with the chosen driver.
      # I think most file managers use ntfs3, but I had some problems moving big folders with it.
      services.udisks2 = {
        enable = true;
        settings = {
          "udisks2.conf" = {
            defaults = {
              encryption = "luks2";
              ntfs_driver = "ntfs-3g";
            };
            udisks2 = {
              modules = [
                "*"
              ];
              modules_load_preference = "ondemand";
            };
          };
        };
      };

      # If needed, we can patch the kernel to enable the module.
      # boot.kernelPatches = [
      #   {
      #     name = "enable-new-ntfs-driver";
      #     patch = null; # No source code patch needed, only a config change
      #     structuredExtraConfig = with lib.kernel; {
      #       NTFS_FS = module; # This sets CONFIG_NTFS_FS=m
      #     };
      #   }
      # ];
    };
  };
}
