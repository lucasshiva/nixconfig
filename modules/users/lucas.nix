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
      (batteries.user-shell "zsh")

      # Cli tools - the same in every host
      aspects.cli.bat
      aspects.cli.eza
      aspects.cli.fzf
      aspects.cli.ripgrep
      aspects.cli.zoxide
    ];
  };
}
