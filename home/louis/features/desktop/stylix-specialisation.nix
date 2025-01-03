{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
in
{
  specialisation = mkIf cfg.stylix.enable {
    light.configuration = {
      stylix.image = ../../../../hosts/common/optional/background.png;
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/google-light.yaml";
    };

    dark.configuration = {
      stylix.image = ../../../../hosts/common/optional/background.png;
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/primer-dark.yaml";
    };
  };
}
