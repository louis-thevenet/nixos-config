{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

let
  inherit (config.home-config.cli.commonTools) enable;
  tomlFormat = pkgs.formats.toml { };
  helixConfigFile = tomlFormat.generate "yazelix-helix-config.toml" config.programs.helix.settings;
  helixLanguagesFile = tomlFormat.generate "yazelix-helix-languages.toml" config.programs.helix.languages;

  # Yazelix's managed Helix uses its own config-dir (~/.config/yazelix/helix),
  # so theme files written by programs.helix (e.g. stylix's generated theme)
  # under ~/.config/helix/themes must be mirrored there too, or it silently
  # falls back to the default theme.
  helixThemeFiles = lib.mapAttrs' (
    name: _:
    lib.nameValuePair "yazelix/helix/themes/${name}.toml" {
      source = config.xdg.configFile."helix/themes/${name}.toml".source;
    }
  ) config.programs.helix.themes;
in
{

  imports = [ inputs.yazelix.homeManagerModules.default ];
  home.packages = with pkgs; [
    noto-fonts
  ];
  xdg.configFile = helixThemeFiles;
  programs.yazelix = {
    inherit enable;
    package = inputs.yazelix.packages.${pkgs.system}.yazelix;
    config = {
      settings = {
        shell = {
          program = "fish";
          atuin = false;
        };
      };
      # Feed the same Helix config/languages used by programs.helix into
      # Yazelix's managed Helix, so keybinds and LSPs stay in sync.
      helix = {
        config.source = helixConfigFile;
        languages = lib.mkIf (config.programs.helix.languages != { }) {
          source = helixLanguagesFile;
        };
      };
    };
  };
}
