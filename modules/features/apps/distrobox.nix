{ shiv, lib, ... }:
let
  # I don't know how well Distrobox works under a normal distro host, but on NixOS the integration
  # isn't very good.
  volumes = [
    # Nix store
    "/nix/store:/nix/store:ro"

    # Home Manager profile
    "/etc/profiles/per-user:/etc/profiles/per-user:ro"
    "/etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"

    # System font config
    "/etc/fonts:/etc/fonts:ro"
  ];
in
{
  shiv.apps.distrobox = {
    includes = [
      shiv.services.podman # Required for distrobox to work.
      shiv.services.flatpak # Might be needed for `distrobox-host-exec`.
    ];

    nixos = {
      environment.etc."distrobox/distrobox.conf".text = ''
        container_additional_volumes="${lib.concatStringsSep " " volumes}"
      '';
    };

    homeManager =
      { pkgs, config, ... }:
      let
        inherit (lib)
          mkOption
          optionals
          optionalAttrs
          types
          ;
        binsPath = "${config.home.homeDirectory}/.local/bin";
        cfg = config.my.distrobox;
      in
      {
        options.my.distrobox = {
          flutter = mkOption {
            type = types.bool;
            description = ''
              Install Flutter dev dependencies in the container.

              Android SDKs are managed on the host via Android Studio.
            '';
            default = false;
          };
          dotnet = mkOption {
            type = types.bool;
            description = ''
              Install .NET dependencies in the container.

              SDKs are currently managed imperatively via `mise`.
            '';
            default = false;
          };
          kdeIntegration = mkOption {
            type = types.bool;
            description = ''
              Install KDE packages in the container.
            '';
            default = false;
          };

          additionalPackages = mkOption {
            type = types.listOf types.str;
            description = "Additional packages to install in the CachyOS/Arch dev container";
            default = [ ];
            example = [
              "git"
              "fzf"
              "eza"
            ];
          };
        };

        config = {
          home.sessionPath = [
            binsPath
          ]
          ++ optionals cfg.dotnet [ "$HOME/.dotnet/tools" ];

          home.shellAliases = {
            dbd = "distrobox enter dev";
            dba = "distrobox assemble create --file ~/.config/distrobox/containers.ini";
          };

          home.sessionVariables = optionalAttrs cfg.dotnet {
            DOTNET_CLI_TELEMETRY_OPTOUT = 1;
          };

          programs.bash.initExtra = ''
            if [ -f /run/.containerenv ]; then
              export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/host/run/user/$(id -u)/bus"
            fi
          '';

          programs.zsh.initContent = ''
            if [ -f /run/.containerenv ]; then
              export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/host/run/user/$(id -u)/bus"
            fi
          '';

          programs.fish.shellInit = ''
            if test -f /run/.containerenv
                set -gx DBUS_SESSION_BUS_ADDRESS "unix:path=/run/host/run/user/"(id -u)"/bus"
            end
          '';

          programs.distrobox = {
            enable = true;
            containers = {
              dev = {
                # cachyos because it more packages in the repo, e.g. `yay`.
                image = "docker.io/cachyos/cachyos:latest";
                hostname = "dev";
                init = true;
                replace = true;
                nvidia = true;
                exported_bins_path = binsPath;
                pre_init_hooks = [
                  "mkdir -p ${binsPath}"
                  "export SHELL=${lib.getExe pkgs.fish}"
                ];
                additional_packages = [
                  "base-devel"
                  "mpv"
                ]
                ++ optionals cfg.kdeIntegration [
                  "qt5-tools"
                  "qt6-tools"
                  "qt6-wayland"
                  "qt6-base"
                  "xdg-utils"

                  # Fixes theme issues, like IDEs using wrong cursors, font sizing, etc.
                  "breeze"
                  "breeze-gtk"

                  # Open things in Dolphin. Registers `inode/directory` on xdg.
                  "dolphin"
                ]
                ++ optionals cfg.flutter [
                  "clang"
                  "cmake"
                  "ninja"
                  "pkgconf"
                  "gtk3"
                  "mesa-utils"
                ]
                ++ optionals cfg.dotnet [
                  # Install latest .NET packages. For previous versions (8.0, 9.0, etc.), suffix
                  # packages with "-8.0" or "-9.0" respectively.
                  "dotnet-runtime"
                  "dotnet-sdk"
                  "aspnet-runtime"
                  "aspnet-targeting-pack"
                ]
                ++ cfg.additionalPackages; # Additional packages defined in other modules.
              };
            };
          };
        };
      };
  };
}
