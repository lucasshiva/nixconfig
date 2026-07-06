{ den, ... }: {

  den.aspects.void.hardware = {
    includes = [ den.aspects.filesystem.ntfs ];
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
          device = "/dev/disk/by-uuid/47BE680932B24776";
          fsType = "ntfs"; # `ntfs` is the new driver available starting from kernel 7.1
          options = [
            "nofail"
            "uid=1000"
            "gid=1000"
            "rw"
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
