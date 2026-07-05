{ den, lib, ... }:
let
  hostname = "void";
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

      # Maybe later we could support multiple desktops at once
      aspects.desktop.niri
      aspects.desktop.dms

      aspects.apps.calibre
      aspects.apps.musicbee
      aspects.apps.firefox

      aspects.gaming.osu
      aspects.hardware.opentabletdriver

      # Not working on KDE. Needs more testing.
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
        my.dms = {
          enableNiriIntegration = true;
        };
      };

    nixos =
      {
        pkgs,
        modulesPath,
        config,
        ...
      }:
      {
        imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

        # Maybe a specific module/aspect for qemu guests?
        services.qemuGuest.enable = true;

        # Random stuff for graphics, niri, etc. Will fix later.
        # I was not able to run niri-session in a VM, so now I have to start testing on bare metal.
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };

        systemd.user.services.niri.enableDefaultPath = false;
        environment.systemPackages = [ pkgs.kitty ]; # Will configure this via home-manager.
        services.gnome.gnome-keyring.enable = true; # Always nice to have.
        security.polkit.enable = true; # Maybe we don't need this since DMS has a polkit?
        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        xdg.portal.config.niri = {
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ]; # or "kde"
        };

        # Replace with Dank Greeter.
        # I think Noctalia also has a greeter, but only for v5. Worth checking it out.
        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              command = "${config.programs.niri.package}/bin/niri-session";
              user = username;
            };
          };
        };

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
