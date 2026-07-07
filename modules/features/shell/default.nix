{ den, ... }:
{
  den.aspects.shell = {
    includes = with den.aspects; [
      # Bash is mostly to make sure that aliases, env vars, etc. are handled correctly.
      shell.bash
      shell.zsh
      shell.nushell
      shell.fish
    ];

    homeManager =
      { config, ... }:
      {
        # Add $HOME/.local/bin to PATH. We usually want this in every system.
        home.sessionPath = [
          "${config.home.homeDirectory}/.local/bin"
        ];
      };
  };
}
