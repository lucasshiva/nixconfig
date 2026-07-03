{ ... }:
{
  # Starts the `spice-vdagent` service to bidirectional clipboard support on virt-manager.
  # The VM must have a `Channel (spice)` hardware with the following:
  #
  # <channel type="spicevmc">
  #   <target type="virtio" name="com.redhat.spice.0"/>
  # </channel>
  den.aspects.services.spice-vdagent = {
    homeManager =
      { pkgs, ... }:
      {
        systemd.user.services.spice-vdagent = {
          Unit = {
            Description = "SPICE guest session agent";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };

          Service = {
            ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent";
            Restart = "on-failure";
          };

          Install.WantedBy = [ "graphical-session.target" ];
        };
      };
  };
}
