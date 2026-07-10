{ shiv, ... }: {

  shiv.void.hardware = {
    includes = [ shiv.filesystem.ntfs ];
    nixos =
      {
        config,
        lib,
        modulesPath,
        ...
      }:
      {
        imports = [
          (modulesPath + "/installer/scan/not-detected.nix")
        ];

        boot.initrd.availableKernelModules = [
          "nvme"
          "xhci_pci"
          "ahci"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/a5b59700-b267-41a2-a221-1f70705f6e6d";
          fsType = "btrfs";
        };

        fileSystems."/home" = {
          device = "/dev/disk/by-uuid/a5b59700-b267-41a2-a221-1f70705f6e6d";
          fsType = "btrfs";
          options = [ "subvol=home" ];
        };

        fileSystems."/nix" = {
          device = "/dev/disk/by-uuid/a5b59700-b267-41a2-a221-1f70705f6e6d";
          fsType = "btrfs";
          options = [ "subvol=nix" ];
        };

        # Shared drive for media, code files, games, etc.
        fileSystems."/mnt/data" = {
          device = "/dev/disk/by-uuid/a2033fec-beef-410c-bff8-dace057bea19";
          # `ntfs` is the new driver available starting from kernel 7.1
          #
          # To use it, we have to blacklist ntfs-3g and ntfs3, but neither ntfs3 or the new drive
          # work well with Steam games, so we're forced to use ntfs-3g if we want ntfs support.
          #
          # I gave up on NTFS for now, so I'll be using ext4 as a shared drive between two linux
          # systems: NixOS and CachyOS.
          fsType = "ext4";
          options = [
            "defaults"
            "nofail"
          ];
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/5315-7A73";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };

        swapDevices = [ ];

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
  };
}
