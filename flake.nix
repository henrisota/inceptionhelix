{
  description = "flak plak";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall = {
      url = "github:snowfallorg/lib";
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
