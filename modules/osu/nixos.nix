{
  ...
}:

{
  my.opentabletdriver.enable = true;
}

# It seems like we can't share options between nixos and home-manager.
# But it's possible to depend on home-manager's config directly, though this slows down evaluation.
# I might enable this in the future, so I'm leaving it here as reference.
#
# {
#   config,
#   lib,
#   username,
#   ...
# }:
# let
#   cfg = config.home-manager.users.${username}.my.osu;
# in
# {
#   config = lib.mkIf cfg.enable {
#     my.opentabletdriver.enable = cfg.enableTabet;
#   };
# }
