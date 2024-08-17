{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
in {
  specialisation = mkIf cfg.stylix.enable {
    light.configuration = {
      stylix.image = ../../../../hosts/common/optional/background_light.jpg;
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
    };

    dark.configuration = {
      stylix.image = ../../../../hosts/common/optional/background_dark.jpeg;
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/windows-highcontrast.yaml";
    };
  };
}
