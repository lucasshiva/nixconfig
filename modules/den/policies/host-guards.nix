{ den, ... }:
{
  den.policies.host-guards =
    { host, ... }:
    [
      (den.lib.policy.resolve {

        # `class` is missing on non-NixOS systems.
        isNixos = (host.class or "") == "nixos";
        isDarwin = (host.class or "") == "darwin";
      })
    ];
}
