{ ... }:
{
  shiv.shell.bash = {
    homeManager.programs.bash = {
      enable = true;

      # Use fish on TTYs. Also avoid it on nix-shells as for some reason it can't find the packages.
      profileExtra = ''
        if [[ $- == *i* ]] \
           && command -v fish >/dev/null \
           && [[ -z "$BASH_NO_FISH" ]] \
           && [[ -z "$IN_NIX_SHELL" ]]; then
            exec fish
        fi
      '';
    };
  };
}
