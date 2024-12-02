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
    base16Scheme = "${pkgs.base16-schemes}/share/themes/google-light.yaml";
    cursor = {
      package = pkgs.numix-cursor-theme;
      name = "Numix-Cursor-Light";
      size = 22;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
  };
}
