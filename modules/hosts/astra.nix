{ shiv, ... }:
let
  username = "lucas";
  hostname = "astra";
in
{
  den.homes.x86_64-linux."${username}@${hostname}" = { };

  # This host/home is usually a CachyOS machine.
  # Check the `cachyos.sh` script for packages installed via pacman.
  den.aspects.${username}.provides.${hostname} = {
    includes = with shiv; [
      hardware.gpu.nvidia
      core.fonts
      services.syncthing

      # NOTE: Due to issues of standalone home-manager on other systems, some apps might not run
      # perfectly, while others might not even run at all.
      apps.osu
      apps.calibre # Works perfectly.
      apps.junction # Also fine, just had to set it as floating on Niri.
      apps.kitty # Seems okay.

      # Variables for Android SDK.
      dev.android

      # No issues when installing via pacman.
      desktop.niri
      desktop.noctalia
    ];

    homeManager =
      { pkgs, config, ... }:
      let
        appsDir = "/mnt/ntfs/Apps";
      in
      {
        # Install the home-manager CLI.
        programs.home-manager.enable = true;

        # Putting this under `den.default.homeManager` on NixOS gives me a warning, so we make this
        # opt-in instead.
        nixpkgs.config.allowUnfree = true;

        my.osu = {
          installPackage = false; # Will install via pacman/yay
          dataDir = "${appsDir}/osu";
        };

        my.calibre.settingsDir = "${appsDir}/Calibre/Calibre Settings";

        # I will probably move kitty to pacman as well, just in case it needs better GPU support.
        # But this means a slight refactor of its aspect.
        my.kitty.shell = config.programs.fish.package;

        targets.genericLinux = {
          # Fixes generic Linux integration (icons, XDG base directories, etc.)
          enable = true;

          # Automatically handles linking GPU drivers and OpenGL for non-NixOS
          gpu.enable = true;
          #gpu.nvidia.enable = false;
        };
      };
  };
}
