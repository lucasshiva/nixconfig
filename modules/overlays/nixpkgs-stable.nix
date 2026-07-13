{ inputs, ... }: {
  shiv.overlays = {
    nixos =
      { pkgs, ... }:
      {
        nixpkgs.overlays = [
          (final: prev: {
            stable = import inputs.nixpkgs-stable {
              system = pkgs.stdenv.hostPlatform.system;
            };
          })
        ];
      };
  };
}
