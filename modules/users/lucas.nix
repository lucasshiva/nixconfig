{ den, ... }:
{
  den.aspects.lucas = {
    includes = with den; [
      # Marks user as the primary (admin-level) user.
      # On NixOS: adds `wheel` and `networkmanager` groups.
      batteries.primary-user

      # Forward all `homeManager` config to the user.
      # Without this, we'd have to include aspects we're already including in the host.
      batteries.host-aspects

      # Shell config
      aspects.shell
      aspects.shell.prompts.starship
      (batteries.user-shell "zsh")

      # Cli tools - the same in every host
      aspects.cli.bat
      aspects.cli.eza
      aspects.cli.fzf
      aspects.cli.ripgrep
      aspects.cli.zoxide
      aspects.cli.direnv
      aspects.cli.devenv

      # Git related stuff
      # Maybe move this to `aspects.git`
      aspects.cli.git
      aspects.cli.delta
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
      };
  };
}
