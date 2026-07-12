{ ... }:
let
  defaultLibs =
    pkgs: with pkgs; [
      zlib
      zstd
      stdenv.cc.cc
      curl
      openssl
      attr
      libssh
      bzip2
      libxml2
      acl
      libsodium
      util-linux
      xz
      systemd
    ];
  steamLibs = pkgs: [
    (pkgs.runCommand "steamrun-lib" { } "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")
  ];
in
{
  shiv.dev.libs = {
    nixos =
      { pkgs, ... }:
      {
        # Helps with unpatched, dynamic binaries. The module already comes with a set of default
        # libraries, but we can add our own based on our needs.
        #
        # See https://github.com/nix-community/nix-ld for usage.
        programs.nix-ld = {
          enable = true;
          libraries =
            with pkgs;
            defaultLibs pkgs
            ++ steamLibs pkgs
            ++ [
              gcc.cc.lib
              glibc
              gtk3
              glib
              cairo
              libGL
              libGLU
              mesa
              libdrm
              libgbm
              wayland
              fontconfig
            ];
        };
      };
  };
}
