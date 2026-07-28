{ shiv, den, ... }:
{
  den.aspects.lucas = {
    includes = with shiv; [
      # Marks user as the primary (admin-level) user.
      # On NixOS: adds `wheel` and `networkmanager` groups.
      den.batteries.primary-user

      # Forward all `homeManager` config to the user.
      # Without this, we'd have to include aspects we're already including in the host.
      den.batteries.host-aspects

      # Shell config
      shell
      shell.prompts.starship
      (den.batteries.user-shell "fish")

      # Cli tools - usually the same in every host
      cli.bat
      cli.eza
      cli.fzf
      cli.ripgrep
      cli.zoxide
      cli.btop
      cli.direnv
      cli.mise
      cli.yazi
      cli.duf

      # Git related stuff
      # Maybe move this to `shiv.git`
      cli.git
      cli.delta
      # TODO: add `gh` later.
    ];

    nixos = { ... }: {
      nix.settings.trusted-users = [
        "root"
        "@wheel"
      ];
    };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          # TODO: enable these packages globally for all users.
          nixfmt
          nil
          nixd
        ];

        my.git = {
          user.name = "Lucas Silva";
          user.email = "silva.lucasdev@gmail.com";
        };

        # Enable home-manager CLI whenever possible
        programs.home-manager.enable = true;
      };
  };
}
