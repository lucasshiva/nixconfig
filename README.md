# NixOS Configuration
My NixOS (and `home-manager`) configuration using the [Den](https://den.denful.dev) framework.

> [!WARNING]
> This configuration is still a **work in progress**. 
> I am still working on making it as composable and modular as possible, mostly for fun, but this means over-engineering things that should probably be hard-coded. You've been warned.

## Structure
```sh
|—— modules/
|—— |—— features/   # Reusable features
|—— |—— den/        # Den configuration and defaults
|—— |—— hosts/      # Host definitions
|—— |—— users/      # User definitions
|—— flake.lock      # Lock file - updated via `nix flake update`
|—— flake.nix       # Input declarations
```

## Machines
| Name | Type | CPU | GPU | RAM |
| --- | --- | --- | --- | --- |
| Home PC | Desktop | AMD Ryzen 7 5700X | NVIDIA RTX 3070 | 32 GB @3200 Mhz |

## Hosts
| Name | Machine | System | Users | Configuration |
| --- | --- | --- | --- | --- |
| void | Home PC | NixOS | lucas | System configuration + `home-manager`.
| astra | Home PC | CachyOS | lucas | standalone `home-manager`.|

## Usage
### Update

```sh
nix flake update
```

### Build

First run on a new system:

```sh
# NixOS
sudo nixos-rebuild switch --flake .#<hostname>

# Standalone home-manager
nix run github:nix-community/home-manager -- switch --flake .#<username>@<hostname>
```

To build on an existing system, we're using [nh](https://github.com/nix-community/nh), a CLI helper for Nix commands.

```nix
# NixOS
nh os switch .
nh os switch .#hostname

# Standalone home-manager
nh home switch .
nh home switch .#username@<hostname>
```


## Secrets

I use `sops-nix` to manage secrets declaratively.

Before using `sops`, we need an SSH `ed25519` key and an Age identity. The Age identity used by SOPS can be generated from the SSH private key, so the SSH key is the source of truth.


### Existing keys

If you already have an SSH key stored in a password manager, restore it first:

```sh
mkdir -p ~/.ssh
nvim ~/.ssh/id_ed25519 # Paste SSH key inside
chmod 600 ~/.ssh/id_ed25519 # Ensure it has the correct permissions
```

Then generate the public key:

```sh
ssh-keygen -y -f ~/.ssh/id_ed25519 > ~/.ssh/id_ed25519.pub
```

After restoring the SSH key, generate the Age identity:

```sh
mkdir -p ~/.config/sops/age
ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt
```

### New keys

If you do not have an SSH key yet, generate one:

```sh
ssh-keygen -t ed25519
```

This creates:

```text
~/.ssh/id_ed25519        # private key
~/.ssh/id_ed25519.pub    # public key
```

Make sure the private key is protected:

```sh
chmod 600 ~/.ssh/id_ed25519
```

Then generate the Age identity from it:

```sh
mkdir -p ~/.config/sops/age
ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt
```

### Public keys

To get the Age public key for `.sops.yaml`, run:

```sh
ssh-to-age -public-key -i ~/.ssh/id_ed25519
```

Example output:

```text
age1l63q7248v02xw2jyj3eygakhaectwfmu7m4dd66dguza4c7hxelqn3lzhs
```

The SSH public key can be regenerated at any time:

```sh
ssh-keygen -y -f ~/.ssh/id_ed25519 > ~/.ssh/id_ed25519.pub
```

### Backup

The SSH private key is important and must be stored somewhere safe, such as a password manager or encrypted backup. Losing it means losing access to services that use it.

The Age identity can always be regenerated from the SSH private key, so keeping the SSH private key safe is the critical part.

Once these files exist, `sops` can decrypt secrets normally.

### Usage
If everything is setup correctly, then run `sops` in the root directory to edit the secrets file:

```sh
# ~/nixconfig
sops modules/features/secrets/secrets.yaml
```

This will open the `secrets.yaml` file with our default editor (based on `$EDITOR`). `sops` will encrypted the file's contents when we close it.

Once that's done, we can get started using the secrets. First, register them somewhere with:

```nix
sops.secrets."syncthing/cert" = {
  # Here we can configure the secret itself, e.g:
  # format =
  # sopsFile =
  # mode = 
};
sops.secrets."syncthing/key" = { };
```

After that, we can reference it inside other modules:

```nix
homeManager = { config, ... }: {
  services.syncthing = {
    enable = true;
    cert = config.sops.secrets."syncthing/cert".path;
    key = config.sops.secrets."syncthing/key".path;
  };
};
```

The examples above assume we have a `secrets.yaml` as follows:

```yaml
syncthing:
  key: <mykey>
  cert: <mycert>
```

Disclaimer: It should be possible to run `sops` directly inside the `secrets` directory, but I haven't really looked into it.

## References

### Configurations
- [sarahlament](https://github.com/sarahlament/nix-configurations).
- [quasigod](https://codeberg.org/quasigod/nixconfig).
- [drupol](https://github.com/drupol/infra).
- [neonvoidx](https://github.com/neonvoidx/nix).
- [Gwenodai](https://github.com/Gwenodai/nixos).
- [Sini](https://github.com/sini/nix-config).
- [Vic](github.com/vic/vix)
- [kiriwalawren](https://github.com/kiriwalawren/dotnix).
- [wallago](https://github.com/wallago/nix-config).

### Documentation
- [Den Framework](https://den.denful.dev).
- [Den Templates](https://github.com/denful/den/tree/main/templates).
- [Dendritic Design](https://github.com/Doc-Steve/dendritic-design-with-flake-parts) by Doc-Steve.
