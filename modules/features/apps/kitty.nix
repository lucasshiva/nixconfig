{ ... }: {
  den.aspects.apps.terminals.kitty = {
    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        cfg = config.my.kitty;
      in
      {
        options.my.kitty = {
          shell = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            description = ''
              The shell package to launch when kitty starts.

              When set to null, kitty uses the user’s default login shell.
            '';
            default = null;
            example = pkgs.zsh;
          };
        };
        config = {
          programs.kitty = {
            enable = true;
            themeFile = "Catppuccin-Mocha";
            enableGitIntegration = lib.mkDefault true;
            shellIntegration = {
              enableBashIntegration = lib.mkDefault true;
              enableZshIntegration = lib.mkDefault true;
              enableFishIntegration = lib.mkDefault true;
            };
            font = lib.mkDefault {
              name = "MonaspiceNe Nerd Font Mono";
              package = pkgs.nerd-fonts.monaspace;
              size = 12;
            };
            settings = {
              shell = lib.mkIf (cfg.shell != null) (lib.getExe cfg.shell);
              background_opacity = "0.90";
            };
          };
        };
      };
  };
}
