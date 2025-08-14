{
  description = "flak plak";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-compat.url = "github:edolstra/flake-compat";
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall = {
      url = "github:snowfallorg/lib";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    lib = inputs.snowfall.mkLib {
      inherit inputs;
      src = ./.;

      snowfall = {
        root = ./.;
        namespace = "flak";
        meta = {
          name = "flak";
          title = "flak";
        };
      };
    };
  in
    lib.mkFlake {
      inherit inputs;
      src = ./.;

      alias = {
        packages = {
          default = "inceptionhelix";
        };
      };

      package-namespace = "flak";
      channels-config = {
        allowUnfree = true;
      };
      outputs-builder = channels: {
        formatter = channels.nixpkgs.alejandra;
      };
    };
}
