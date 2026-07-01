{ den, ... }:
{
  den.aspects.lucas = {
    includes = [
      # Marks user as the primary (admin-level) user.
      # On NixOS: adds `wheel` and `networkmanager` groups.
      den.batteries.primary-user

      # Forward all `homeManager` config to the user.
      # Without this, we'd have to include aspects we're already including in the host.
      den.batteries.host-aspects
    ];
  };
}
