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

      # Maybe we don't need to manually manage fontconfig when using a DE.
      # They all seem to add fonts and/or manage fontconfig themselves.
      aspects.core.fonts
      aspects.swap.zram
      aspects.sound.pipewire
      aspects.boot.systemd-boot

      # KDE UI elements are rather slow on NixOS, so for now I'm going to be using something else.
      # For more information, see https://github.com/NixOS/nixpkgs/issues/126590.
      # The workaround did not work for me.
      # aspects.desktop.kde

      # I'm trying out Cosmic for now, but I'm probably going to be using GNOME and/or Niri instead.
      aspects.desktop.cosmic

      aspects.apps.calibre
      aspects.apps.musicbee
      aspects.apps.firefox
      aspects.apps.zed

      aspects.gaming.osu
      aspects.hardware.opentabletdriver
    ];

    homeManager =
      { pkgs, ... }:
      let
        dataDrive = "/mnt/data";
      in
      {
        my.calibre.settingsDir = "${dataDrive}/Apps/Calibre/Calibre Settings";
        my.musicbee.appDir = "${dataDrive}/Apps/MusicBee";
        my.osu.dataDir = "${dataDrive}/Apps/osu!";

        home.packages = with pkgs; [
          neovim
          keepassxc
          obsidian
        ];
      };

    nixos =
      { pkgs, ... }:
      {
        # Will disable later if I stop using Cosmic.
        my.cosmic.autoLogin = true;

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
