<h1 align="center">
   <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/logo/nix-snowflake-colours.svg" width="100px" />
   <br>
   inceptionhelix
   <div align="center">
      <p></p>
      <div align="center">
         <a>
            <img src="https://img.shields.io/badge/Nix-Unstable-blue?style=for-the-badge&logo=nixos&label=NIX&labelColor=303446&color=94e2d5">
         </a>
         <a href="https://github.com/snowfallorg/lib" target="_blank">
            <img alt="Built With Snowfall" src="https://img.shields.io/static/v1?label=Built%20With&labelColor=303446&message=Snowfall&color=94e2d5&style=for-the-badge">
         </a>
         <a href="https://github.com/henrisota/inception/blob/main/LICENSE">
            <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&colorA=313244&colorB=FAB387&logo=unlicense&logoColor=FAB387&labelColor=303446"/>
         </a>
      </div>
   </div>
</h1>

`inception` configuration for [Helix](https://helix-editor.com/) in [Nix](https://nixos.org/) using [Flakes](https://nixos.wiki/wiki/Flakes)

## Installation

Add it as an input to your flake

```nix
inputs.inceptionhelix.url = "github:henrisota/inceptionhelix";
```

Set it as a package in your configuration

### Home Manager

```nix
home.packages = [inputs.inceptionhelix.packages.${system}.default];
```

### NixOS

```nix
environment.systemPackages = [inputs.inceptionhelix.packages.${system}.default];
```

## Development

To easily test the current `main` configuration, simply run the following command

```shell
nix run github:henrisota/inceptionhelix
```

For local development and testing changes, clone the repository and run the following command

```shell
nix run .
```

Pass in arguments to `helix` via operands

```
nix run github:henrisota/inceptionhelix -- ./
```

## Structure

Configuration is set under [configuration](./configuration/).

Overall flake structure follows [Snowfall](https://snowfall.org/).
