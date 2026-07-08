{ ... }: {
  den.aspects.shell.fish.homeManager = { ... }: {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting
      '';
    };
  };
}
