# NixOS Configuration
My NixOS (and `home-manager`) configuration using the [Den](https://den.denful.dev) framework.

> [!WARNING]
> This configuration is still a **work in progress**. I am currently developing and testing it in virtual machines before trying it out on bare metal.

## Structure
```sh
|—— modules/
|—— |—— aspects/    # Reusable features
|—— |—— den/        # Den configuration and defaults
|—— |—— hosts/      # Host definitions
|—— |—— users/      # User definitions
|—— flake.lock      # Lock file - updated via `nix flake update`
|—— flake.nix       # Input declarations
```

## Machines
| Name | Type | CPU | GPU | RAM |
| --- | --- | --- | --- | --- |
| Main | Desktop | AMD Ryzen 7 5700X | NVIDIA RTX 3070 | 32 GB @3200 Mhz |

## Hosts
| Name | Machine | System | Users | Configuration |
| --- | --- | --- | --- | --- |
| void | Main | NixOS | lucas | System configuration + `home-manager`.
| astra | Main | CachyOS | lucas | standalone `home-manager`.|

## Usage
To update the system, run:

```sh
nix flake update
```

To build the system, we're using [nh](https://github.com/nix-community/nh) - a CLI helper.

For NixOS, run:

```sh
nh os switch .
nh os switch .#hostname
```

For standalone `home-manager`, we have two options:

1. First run on a new system:

```sh
nix run github:nix-community/home-manager -- switch --flake .#<username>
```

2. Build on an existing system:

```sh
nh home switch .
nh home switch .#username
```

## References

### Configurations
- [sarahlament](https://github.com/sarahlament/nix-configurations).
- [quasigod](https://codeberg.org/quasigod/nixconfig).
- [drupol](https://github.com/drupol/infra).
- [neonvoidx](https://github.com/neonvoidx/nix).
- [Gwenodai](https://github.com/Gwenodai/nixos).
- [Sini](https://github.com/sini/nix-config).
- [kiriwalawren](https://github.com/kiriwalawren/dotnix).
- [wallago](https://github.com/wallago/nix-config).

### Documentation
- [Den Framework](https://den.denful.dev).
- [Den Templates](https://github.com/denful/den/tree/main/templates).
- [Dendritic Design](https://github.com/Doc-Steve/dendritic-design-with-flake-parts) by Doc-Steve.
