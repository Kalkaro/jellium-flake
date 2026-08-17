# Jellium Desktop Flake

A Nix package for the [Jellium Desktop](https://github.com/andrewrabert/jellium-desktop) Jellyfin client.

## Usage

### Run directly

```sh
nix run github:Kalkaro/jellium-flake
```

## Installation

### NixOS Configuration

Add the flake to your inputs and include the package in `environment.systemPackages`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    jellium.url = "github:Kalkaro/jellium-flake";
  };

  outputs = { self, nixpkgs, jellium, ... }: {
    nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = [
            jellium.packages.${pkgs.system}.default
          ];
        })
      ];
    };
  };
}
```

### Home Manager

Add the flake to your inputs and include the package in `home.packages`:

```nix
{
  home.packages = [
    inputs.jellium.packages.${pkgs.system}.default
  ];
}
```

## License

The Nix packaging code in this repository is available under the MIT license.
Jellium Desktop itself is fetched from upstream and remains licensed under
GPL-2.0-only.
