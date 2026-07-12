{ ... }: {
  shiv.apps.junction = {
    homeManager =
      { pkgs, ... }:
      let
        desktopName = "re.sonny.Junction.desktop";
      in
      {
        home.packages = [ pkgs.junction ];

        # TODO: create an aspect for `xdg` config.
        # xdg.mimeApps = {
        #   enable = true;
        #   defaultApplications = {
        #     "x-scheme-handler/http" = desktopName;
        #     "x-scheme-handler/https" = desktopName;
        #     "text/html" = desktopName;
        #   };
        # };
      };
  };
}
