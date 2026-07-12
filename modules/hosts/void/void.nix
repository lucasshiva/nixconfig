{ shiv, ... }:
let
  hostname = "void";
  username = "lucas";
in
{
  den.hosts.x86_64-linux."${hostname}" = {
    users."${username}" = { };
  };

  den.aspects."${hostname}" = {
    includes = with shiv; [
      void.hardware # Hardware config for this host.
      hardware.gpu.nvidia
      hardware.cpu.amd
      hardware.pc.ssd
      hardware.all-firmware

      # Maybe we don't need to manually manage fontconfig when using a DE.
      # They all seem to add fonts and/or manage fontconfig themselves.
      core.fonts
      swap.zram
      sound.pipewire
      boot.systemd-boot
      dev.libs

      # KDE UI elements are rather slow on NixOS, see https://github.com/NixOS/nixpkgs/issues/126590.
      # Sadly, I didn't feel any difference with the workaround, so I'm not doing it anymore.
      desktop.kde

      apps.calibre
      apps.musicbee
      apps.firefox
      apps.junction
      apps.zed
      apps.vscode
      apps.kitty
      apps.steam
      apps.android-studio

      # We could make `opentabletdriver` opt-out instead of opt-in. In this case, it would be
      # included automatically in osu.
      apps.osu
      hardware.opentabletdriver

      services.syncthing
      secrets.sops
    ];

    homeManager =
      { pkgs, config, ... }:
      let
        dataDrive = "/mnt/data";
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
        ];
      };

    nixos =
      { pkgs, ... }:
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
      };
  };
}
