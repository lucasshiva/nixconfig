# Disk Usage/Free Utility - a better `df` alternative.
{
  shiv.cli.duf.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.duf ];
  };
}
