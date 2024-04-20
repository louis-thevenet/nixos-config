{lib, ...}: let
  inherit (lib) mkEnableOption mkOption;
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

      lmstudio.enable = mkEnableOption ''
        Enable LMStudio
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
      hyprland = {
        enable = mkEnableOption ''
          Enable Hyprland
        '';

        hypridleConfig = {
          screenDimTime = mkOption {
            type = lib.types.ints.u32;
            default = 90;
            description = "Screen dim time in seconds";
          };
          lockTime = mkOption {
            type = lib.types.ints.u32;
            default = 120;
            description = "Lock time in seconds";
          };

          suspendTime = mkOption {
            type = lib.types.ints.u32;
            default = 300;
            description = "Suspend time in seconds";
          };
        };
      };

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
