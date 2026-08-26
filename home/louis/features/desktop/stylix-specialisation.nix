{
  inputs,
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
  imports = [
    inputs.stylix.homeModules.stylix
  ];
  stylix = mkIf cfg.stylix.enable {
    enable = true;
    polarity = lib.mkDefault "light";
    image = ../../../../hosts/common/optional/background.png;
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/google-light.yaml";
    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
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
  specialisation = mkIf cfg.stylix.enable {
    light.configuration.stylix = {
      polarity = "light";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/google-light.yaml";
    };

    dark.configuration.stylix = {
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/evenok-dark.yaml";
    };
  };
}
