{
  pkgs,
  lib,
  config,
  ...
}:
{
  stylix = {
    enable = true;
    image = lib.mkDefault ./background_light.png;
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
    cursor = {
      package = pkgs.numix-cursor-theme;
      name = "Numix-Cursor-Light";
      size = 22;
    };
    fonts = {
      monospace = {
        name = "FiraCode Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
  };
}
