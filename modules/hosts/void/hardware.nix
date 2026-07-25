{ ... }: {

  shiv.void.hardware = {
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
          device = "/dev/disk/by-uuid/accdbb04-407f-4df8-bf08-1dd23d9665c2";
          fsType = "btrfs";
        };

        fileSystems."/home" = {
          device = "/dev/disk/by-uuid/accdbb04-407f-4df8-bf08-1dd23d9665c2";
          fsType = "btrfs";
          options = [ "subvol=home" ];
        };

        fileSystems."/nix" = {
          device = "/dev/disk/by-uuid/accdbb04-407f-4df8-bf08-1dd23d9665c2";
          fsType = "btrfs";
          options = [ "subvol=nix" ];
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/5315-7A73";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };

        # Shared drive for Linux systems. Usually keep my code projects in here.
        fileSystems."/mnt/data" = {
          device = "/dev/disk/by-uuid/18d15419-79f7-4d2d-a7b1-5cde3440fb98";
          fsType = "ext4";
          options = [
            "defaults"
            "rw"
            "uid=1000"
            "gid=1000"
            "nofail"
          ];
        };

        fileSystems."/mnt/ntfs" = {
          device = "/dev/disk/by-uuid/38AA46B56314746E";
          fsType = "ntfs-3g";
          options = [
            "defaults"
            "rw"
            "uid=1000"
            "gid=1000"
            "nofail"
          ];
        };

        swapDevices = [ ];

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
  };
}
