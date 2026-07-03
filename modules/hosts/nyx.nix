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
    includes = with den; [
      aspects.core.fonts
      aspects.boot.systemd-boot
      aspects.desktop.gnome
      aspects.apps.calibre
      aspects.gaming.osu
      aspects.hardware.opentabletdriver
      aspects.apps.musicbee
      aspects.services.spice-vdagent
    ];

    homeManager =
      { ... }:
      {
        my.calibre.settingsDir = "/mnt/commondata/Apps/Calibre/Calibre Settings";
        my.osu.dataDir = "/mnt/commondata/Apps/osu";
        my.musicbee = {
          portableAppDir = "/mnt/commondata/Apps/MusicBee";
          libraryMountPoint = "/mnt/commondata";
          libraryDriveLetter = "f";
        };
      };

    nixos =
      {
        pkgs,
        modulesPath,
        ...
      }:
      {
        imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

        services.spice-vdagentd.enable = true;
        services.qemuGuest.enable = true;

        # Use latest kernel.
        boot.kernelPackages = pkgs.linuxPackages_latest;

        # Enable X11.
        services.xserver.enable = true;

        # Configure keymap in X11
        services.xserver.xkb = {
          layout = "us";
          variant = "altgr-intl";
          options = "compose:rwin";
        };

        # Timezone. We can hardcode it since this host is a PC.
        time.timeZone = "America/Sao_Paulo";

        # Keeps sudo auth valid for one hour.
        security.sudo.extraConfig = ''
          Defaults timestamp_timeout=60
        '';

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

        # Needed for some apps.
        fileSystems."/mnt/commondata" = {
          device = "commondata";
          fsType = "virtiofs";
          options = [
            "nofail"
            "X-mount.mkdir"
          ];
        };
      };
  };
}
