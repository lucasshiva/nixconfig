{ ... }: {
  shiv.apps.android-studio.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.android-studio ];
  };
}
