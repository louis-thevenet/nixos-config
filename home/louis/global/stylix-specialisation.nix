{
  pkgs,
  lib,
  ...
}: {
  specialisation = {
    light.configuration = {
      stylix.base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
    };

    dark.configuration = {
      stylix.base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
    };
  };
}
