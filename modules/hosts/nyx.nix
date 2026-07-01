{ den, lib, ... }:
let
  hostname = "nyx";
  username = "lucas";
in
{
  den.hosts.x86_64-linux."${hostname}" = {
    users."${username}" = { };
  };

  den.aspects."${hostname}" = {
    includes = [ den.aspects.desktop.gnome ];

    nixos =
      {
        pkgs,
        modulesPath,
        ...
      }:
      {
        imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

        # Bootloader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # Use latest kernel.
        boot.kernelPackages = pkgs.linuxPackages_latest;

        # Enable networking
        networking.networkmanager.enable = true;

        # Enable X11.
        services.xserver.enable = true;

        # Configure keymap in X11
        services.xserver.xkb = {
          layout = "us";
          variant = "altgr-intl";
          options = "compose:rwin";
        };

        # Timezone and locale settings
        time.timeZone = "America/Sao_Paulo";
        i18n.defaultLocale = "en_US.UTF-8";
        i18n.extraLocaleSettings = {
          LC_ADDRESS = "pt_BR.UTF-8";
          LC_IDENTIFICATION = "pt_BR.UTF-8";
          LC_MEASUREMENT = "pt_BR.UTF-8";
          LC_MONETARY = "pt_BR.UTF-8";
          LC_NAME = "pt_BR.UTF-8";
          LC_NUMERIC = "pt_BR.UTF-8";
          LC_PAPER = "pt_BR.UTF-8";
          LC_TELEPHONE = "pt_BR.UTF-8";
          LC_TIME = "pt_BR.UTF-8";
        };

        boot.initrd.availableKernelModules = [
          "ahci"
          "xhci_pci"
          "virtio_pci"
          "sr_mod"
          "virtio_blk"
        ];

        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/8cc367d4-cc45-47ba-8d1c-8f0592530719";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/B38D-FC0B";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };

        swapDevices = [
          { device = "/dev/disk/by-uuid/ef36b31d-c193-47bc-a8f6-335105e293bb"; }
        ];

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

        # Make the config folder available in the VM.
        fileSystems."/home/${username}/nixconfig" = {
          device = "nixconfig";
          fsType = "virtiofs";
          options = [
            "nofail"
            "X-mount.mkdir"
          ];
        };
      };
  };
}
