{ den, ... }:
{
  den.aspects.lucas = {
    includes = [
      # Marks user as the primary (admin-level) user.
      # On NixOS: adds `wheel` and `networkmanager` groups.
      den.batteries.primary-user
    ];
  };
}
