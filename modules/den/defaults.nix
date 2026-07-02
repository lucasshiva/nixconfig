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

    # Allow unfree packages.
    nixpkgs.config.allowUnfree = true;

    # Enable flakes.
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Enable networking.
    networking.networkmanager.enable = true;

    # Locale settings
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };

    # Configure home-manager.
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

    # Adds `isNixos` and `isDarwin` variables to `nixos` and `homeManager` configurations.
    den.policies.host-guards
  ];
}
