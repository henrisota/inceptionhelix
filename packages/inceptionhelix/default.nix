{
  lib,
  inputs,
  system,
  pkgs,
  ...
} @ args: let
  package = inputs.helix.packages.${system}.default;

  dependencies = import ./dependencies.nix args;
  configuration = import ../../configuration/default.nix args;
  languagesConfiguration = import ../../configuration/languages/default.nix args;

  tomlFormat = pkgs.formats.toml {};
  configurationToml = (pkgs.formats.toml {}).generate "config.toml" configuration;
  languagesToml = (pkgs.formats.toml {}).generate "languages.toml" languagesConfiguration;
in
  pkgs.symlinkJoin {
    name = "hx";
    paths = [package] ++ dependencies;
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      mkdir -p $out/config/helix
      cp ${configurationToml} $out/config/helix/config.toml
      cp ${languagesToml} $out/config/helix/languages.toml
      wrapProgram $out/bin/hx \
        --set XDG_CONFIG_HOME "$out/config" \
        --prefix PATH : ${pkgs.lib.makeBinPath dependencies}
    '';
  }
