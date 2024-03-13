{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.home-config = {
    cli = {
      CommonTools.enable = mkEnableOption ''
        Enable common CLI Tools
      '';
      VPNC.enable = mkEnableOption ''
        Enable VPNC
      '';
    };

    gui = {
      Kitty.enable = mkEnableOption ''
        Enable Kitty
      '';

      Schizofox.enable = mkEnableOption ''
        Enable Schizofox
      '';

      Social.enable = mkEnableOption ''
        Enable Social
      '';

      Utils.enable = mkEnableOption ''
        Enable common GUI Tools
      '';
    };

    dev = {
      VsCode.enable = mkEnableOption ''
        Enabe VsCode
      '';

      JetBrains.enable = mkEnableOption ''
        Enable Jetbrains
      '';

      DevTools.enable = mkEnableOption ''
        Enable common Dev Tools
      '';
    };

    desktop = {
      Hyprland.enable = mkEnableOption ''
        Enable Hyprland
      '';

      Gnome.enable = mkEnableOption ''
        Enable Gnome
      '';
    };

    gaming = {
      Gaming.enable = mkEnableOption ''
        Enable Gaming
      '';
    };

    virtualization = {
      Virtualization.enable = mkEnableOption ''
        Enable Virtualization
      '';
    };
  };
}
