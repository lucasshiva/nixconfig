{ ... }:
{
  shiv.shell.bash = {
    homeManager.programs.bash = {
      enable = true;
      initExtra = ''
        # Start fish for interactive TTY sessions, unless explicitly disabled.
        if [[ $- == *i* ]] && command -v fish >/dev/null && [[ -z "$BASH_NO_FISH" ]]; then
          exec fish
        fi
      '';
    };
  };
}
