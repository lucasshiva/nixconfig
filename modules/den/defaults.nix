{ ... }:
let
  stateVersion = "26.05";
in
{
  den.default.homeManager = {
    home.stateVersion = stateVersion;
  };

  den.default.nixos = {
    system.stateVersion = stateVersion;
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    home-manager = {
      backupFileExtension = "backup";
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };
}
