{ lib, ... }:
{
  shiv.cli.bat = {
    homeManager =
      { pkgs, config, ... }:
      {
        programs.bat = {
          enable = true;
          extraPackages =
            with pkgs.bat-extras;
            [
              batman # Man pages with bat
            ]
            # Search through and highlight files using `ripgrep`.
            ++ lib.optionals config.programs.ripgrep.enable [ batgrep ];
        };
      };
  };
}
