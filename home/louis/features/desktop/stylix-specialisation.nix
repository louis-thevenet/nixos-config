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
      stylix.base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
    };

    dark.configuration = {
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/windows-highcontrast.yaml";
    };
  };
}
