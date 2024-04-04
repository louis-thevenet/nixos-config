{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.home-config = {
    cli = {
      commonTools.enable = mkEnableOption ''
        Enable common CLI Tools
      '';
      nvTop.enable = mkEnableOption ''
        Enable nvTop
      '';

      VPNC.enable = mkEnableOption ''
        Enable VPNC
      '';
    };

    gui = {
      kitty.enable = mkEnableOption ''
        Enable Kitty
      '';

      schizofox.enable = mkEnableOption ''
        Enable Schizofox
      '';

      social.enable = mkEnableOption ''
        Enable Social
      '';

      utils.enable = mkEnableOption ''
        Enable common GUI Tools
      '';
    };

    dev = {
      vscode.enable = mkEnableOption ''
        Enabe VsCode
      '';

      jetbrains.enable = mkEnableOption ''
        Enable Jetbrains
      '';

      devTools.enable = mkEnableOption ''
        Enable common Dev Tools
      '';
    };

    desktop = {
      hyprland.enable = mkEnableOption ''
        Enable Hyprland
      '';

      gnome.enable = mkEnableOption ''
        Enable Gnome
      '';
    };

    gaming.enable = mkEnableOption ''
      Enable Gaming
    '';

    virtualization.enable = mkEnableOption ''
      Enable Virtualization
    '';
  };
}
