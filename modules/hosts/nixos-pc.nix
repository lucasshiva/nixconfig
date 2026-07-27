{ shiv, ... }:
let
  hostname = "nixos-pc";
  username = "lucas";
in
{
  den.hosts.x86_64-linux."${hostname}" = {
    users."${username}" = { };
  };

  # Would be nice if we could decide between running home-manager as a nixos module or standalone on the fly.
  # den.homes.x86_64-linux."${username}@${hostname}" = { };

  den.aspects."${hostname}" = {
    includes = with shiv; [
      hardware.gpu.nvidia
      hardware.cpu.amd
      hardware.pc.ssd
      hardware.all-firmware

      # Managing fontconfig ourselves is good for Window Managers and Distrobox.
      core.fonts
      swap.zram
      sound.pipewire
      boot.systemd-boot

      # Dev-related config
      dev.android # Configure PATH for Android SKDs. The SKDs are managed via Android Studio.

      # Still required to open dynamically-linked binaries, like from JetBrains Toolbox.
      # To not depend too much on this, we could refactor to module to expose a small set of libs.
      dev.libs

      # KDE UI elements are rather slow on NixOS, see https://github.com/NixOS/nixpkgs/issues/126590.
      # Sadly, I didn't feel any difference with the workaround, so I'm not doing it anymore.
      desktop.kde
      desktop.niri
      desktop.noctalia

      apps.calibre
      apps.musicbee
      apps.firefox
      apps.junction
      apps.zed
      apps.vscode
      apps.kitty
      apps.steam
      apps.discord

      # We could make `opentabletdriver` opt-out instead of opt-in. In this case, it would be
      # included automatically in osu.
      apps.osu
      hardware.opentabletdriver

      services.syncthing
      services.podman
      secrets.sops
    ];

    homeManager =
      { pkgs, config, ... }:
      let
        dataDrive = "/mnt/ntfs";
      in
      {
        my.calibre.settingsDir = "${dataDrive}/Apps/Calibre/Calibre Settings";
        my.musicbee.appDir = "${dataDrive}/Apps/MusicBee";
        my.osu.dataDir = "${dataDrive}/Apps/osu!";
        my.kitty.shell = config.programs.fish.package;

        home.packages = with pkgs; [
          neovim
          keepassxc
          obsidian
          jetbrains-toolbox
          fooyin
        ];
      };

    nixos =
      {
        pkgs,
        modulesPath,
        lib,
        config,
        ...
      }:
      {
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

        # Keeps sudo auth valid for one hour. Useful when you're always rebuilding your configuration.
        security.sudo.extraConfig = ''
          Defaults timestamp_timeout=60
        '';

        environment.systemPackages = with pkgs; [
          kdiskmark
        ];

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
          device = "/dev/disk/by-uuid/176a3952-2cfa-414c-8e8e-486e60a0c0e3";
          fsType = "btrfs";
        };

        fileSystems."/home" = {
          device = "/dev/disk/by-uuid/176a3952-2cfa-414c-8e8e-486e60a0c0e3";
          fsType = "btrfs";
          options = [ "subvol=home" ];
        };

        fileSystems."/nix" = {
          device = "/dev/disk/by-uuid/176a3952-2cfa-414c-8e8e-486e60a0c0e3";
          fsType = "btrfs";
          options = [ "subvol=nix" ];
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/C1B4-1550";
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
