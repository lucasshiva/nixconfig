{ lib, ... }:
{
  # Enable `home-manager` for all users by default, unless they specify other classes.
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
