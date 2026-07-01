{ den, ... }:
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

  den.default.includes = [
    # For NixOS: sets `users.users.<name>`
    # For Home Manager: sets `home.username`/`home.homeDirectory`.
    #
    # Works in both host-user and standalone home contexts.
    den.batteries.define-user

    # Sets the system hostname as defined in `den.hosts.<system>.hostName`.
    den.batteries.hostname
  ];
}
