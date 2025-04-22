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
    light.configuration.stylix = {
      polarity = "light";
      image = ../../../../hosts/common/optional/background.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/google-light.yaml";
    };

    dark.configuration.stylix = {
      polarity = "dark";
      image = ../../../../hosts/common/optional/background.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/evenok-dark.yaml";
    };
  };
}
