{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.home-config = {
    cli = {
      enableCommonTools = mkEnableOption ''
        Enable common CLI Tools
      '';
      enableVPNC = mkEnableOption ''
        Enable VPNC
      '';
    };

    gui = {
      enableKitty = mkEnableOption ''
        Enable Kitty
      '';

      enableSchizofox = mkEnableOption ''
        Enable Schizofox
      '';

      enableSocial = mkEnableOption ''
        Enable Social
      '';

      enableUtils = mkEnableOption ''
        Enable common GUI Tools
      '';
    };

    dev = {
      enableVsCode = mkEnableOption ''
        Enabe VsCode
      '';

      enableJetBrains = mkEnableOption ''
        Enable Jetbrains
      '';

      enableDevTools = mkEnableOption ''
        Enable common Dev Tools
      '';
    };

    desktop = {
      enableHyprland = mkEnableOption ''
        Enable Hyprland
      '';

      enableGnome = mkEnableOption ''
        Enable Gnome
      '';
    };

    gaming = {
      enableGaming = mkEnableOption ''
        Enable Gaming
      '';
    };

    virtualization = {
      enableVirtualization = mkEnableOption ''
        Enable Virtualization
      '';
    };
  };
}
