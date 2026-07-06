{ lib, ... }: {
  den.aspects.filesystem.ntfs = {
    nixos = { pkgs, ... }: {
      # It seems like we don't need to enable the "ntfs" module for the new driver. Needs more testing.
      # boot.kernelModules = [ "ntfs" ];

      # Ensure we're not adding `ntfs-3g` by enabling "ntfs";
      boot.supportedFilesystems = lib.mkForce [
        "btrfs"
        "ext4"
      ];

      # Disable older ntfs modules
      boot.blacklistedKernelModules = [
        "ntfs3" # fast but always buggy
        "ntfs-3g" # slow but super reliable
      ];

      # Userspace utilities for the new ntfs driver.
      environment.systemPackages = [ pkgs.ntfsprogs-plus ];

      # Ensures Dolphin (and maybe other file managers) auto mounts NTFS drives with the new in-kernel driver.
      services.udisks2 = {
        enable = true;
        settings = {
          "udisks2.conf" = {
            defaults = {
              encryption = "luks2";
              ntfs_driver = "ntfs"; # new driver.
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
