{ ... }: {
  shiv.apps.vscode = {
    homeManager = { pkgs, ... }: {
      programs.vscode = {
        enable = true;
        mutableExtensionsDir = true;

        # Add extension-specific dependencies. These are for rust.
        package = pkgs.vscode.fhsWithPackages (
          ps: with ps; [
            rustup
            zlib
            openssl.dev
            pkg-config
          ]
        );
      };

      home.sessionVariables = {
        # Make VS Code run on Wayland native instead of Xwayland.
        NIXOS_OZONE_WL = 1;
      };
    };
  };
}
