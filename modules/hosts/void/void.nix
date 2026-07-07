{ den, ... }:
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
      aspects."${hostname}".hardware # Hardware config for this host.
      aspects.hardware.gpu.nvidia
      aspects.hardware.cpu.amd
      aspects.hardware.pc.ssd

      # KDE already configures fontconfig in its nixos module.
      # Maybe we add an option to only install font packages and not configure anything.
      # Or an option to force our config instead and see if KDE picks it up by default.
      aspects.core.fonts
      aspects.boot.systemd-boot

      # Maybe later we could support multiple desktops at once
      aspects.desktop.kde # TODO: Check out the kde config flake.

      # aspects.apps.calibre
      aspects.apps.musicbee
      aspects.apps.firefox
      aspects.apps.zed

      #aspects.gaming.osu
      #aspects.hardware.opentabletdriver
    ];

    homeManager =
      { pkgs, ... }:
      {
        # -- Disabled for now. Will update it later --
        #
        #my.calibre.settingsDir = "/mnt/commondata/Apps/Calibre/Calibre Settings";
        #my.osu.dataDir = "/mnt/commondata/Apps/osu";

        my.musicbee.appDir = "/mnt/data/Apps/MusicBee";

        home.packages = with pkgs; [
          neovim
          keepassxc
          obsidian
        ];
      };

    nixos =
      { pkgs, ... }:
      {
        # Use latest kernel.
        boot.kernelPackages = pkgs.linuxPackages_latest;

        hardware.enableAllFirmware = true;

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
          kitty # Move to its own module
          kdiskmark
        ];
      };
  };
}
