{ ... }:
{
  # TODO: turn this into a options/config module.
  # Syntax highlighting for git diffs.
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      dark = true;
      side-by-side = true;
      line-numbers = true;
      syntax-theme = "Catppuccin Mocha";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Lucas Silva";
      user.email = "silva.lucasdev@gmail.com";
      init.defaultBranch = "main";
      merge.conflictStyle = "zdiff3"; # For `delta`.
    };
  };
}
