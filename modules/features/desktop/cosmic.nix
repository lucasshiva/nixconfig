{
  den.aspects.desktop.cosmic =
    # Requesting `user` on the `nixos` class module isn't working. Maybe on purpose.
    # For more information, see my issue at https://github.com/denful/den/issues/629
    { user, ... }:
    {
      nixos =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          cfg = config.my.cosmic;
        in
        {
          options.my.cosmic = {
            autoLogin = lib.mkOption {
              type = lib.types.bool;
              description = "Whether to enable auto login for Cosmic Greeter.";
              example = true;
              default = false;
            };
          };

          config = {
            # Enable the COSMIC login manager
            services.displayManager.cosmic-greeter.enable = true;

            # Enable the COSMIC desktop environment
            services.desktopManager.cosmic.enable = true;

            # Exclude packages
            # environment.cosmic.excludePackages = with pkgs; [
            #   cosmic-edit
            # ];
            #
            environment.systemPackages = with pkgs; [
              cosmic-monitor
            ];

            # Improve performance slightly by enabling System76's own scheduler
            # For more information, see https://github.com/pop-os/system76-scheduler
            services.system76-scheduler.enable = true;

            # Bypass security measures for Wayland, giving all windows access to the clipboard.
            # We could make this configurable as well.
            environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

            # Maybe we could move this to a more generic module, included in all desktop environments.
            services.displayManager.autoLogin = lib.mkIf cfg.autoLogin {
              enable = true;
              user = user.userName;
            };
          };
        };
    };
}
