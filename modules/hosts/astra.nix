{ shiv, ... }:
let
  username = "lucas";
  hostname = "astra";
in
{
  den.homes.x86_64-linux."${username}@${hostname}" = { };

  den.aspects.${username}.provides.${hostname} = {
    includes = with shiv; [
      core.fonts
      services.syncthing

      # NOTE: Due to issues of standalone home-manager on other systems, some apps might not run
      # perfectly, while others might not even run at all.
      apps.osu
      apps.calibre # Works perfectly.

      # Fine, but not on Niri. Moving the window with Super + Mouse makes it disappear but keeps it alive in the background. Certainly a Wine issue.
      apps.musicbee

      apps.junction # Also fine, just had to set it as floating on Niri.
      apps.zed # Doesn't run perfectly. Complains about emulated GPU.
      apps.kitty # Seems okay.

      /*
        Some issues with Noctalia Greeter not being to authenticate after coming back from sleep
        Niri itself seems fine though.

        As for KDE, it is better in some cases, worse in others. In NixOS, I get a basic Qt portal,
        but in Arch I actually get Dolphin. That's a plus for Arch. However, it seems like KWallet
        isn't running by default, so I installed gnome-keyring as well. This needs more testing.
      */
      desktop.niri
    ];

    homeManager =
      { pkgs, config, ... }:
      let
        appsDir = "/mnt/data/Apps";
      in
      {
        # Install the home-manager CLI.
        programs.home-manager.enable = true;

        # Putting this under `den.default.homeManager` on NixOS gives me a warning, so we make this
        # opt-in instead.
        nixpkgs.config.allowUnfree = true;

        my.osu = {
          installPackage = true;
          dataDir = "${appsDir}/osu";
        };

        my.calibre.settingsDir = "${appsDir}/Calibre/Calibre Settings";
        my.musicbee.appDir = "${appsDir}/MusicBee";
        my.kitty.shell = config.programs.fish.package;

        home.packages = with pkgs; [
          keepassxc
          obsidian
        ];

        targets.genericLinux = {
          # Fixes generic Linux integration (icons, XDG base directories, etc.)
          enable = true;

          # Automatically handles linking GPU drivers and OpenGL for non-NixOS
          gpu.enable = true;
        };
      };
  };
}
