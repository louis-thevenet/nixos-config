{ lib, ... }:
let
  inherit (lib) mkEnableOption mkOption;
in
{
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

      schizofox = {
        enable = mkEnableOption ''
          Enable Schizofox
        '';

        searxngInstance = mkOption {
          type = lib.types.str;
          default = "https://searxng.brihx.fr";
          description = ''
            URL for searxng instance
          '';
        };
      };

      social.enable = mkEnableOption ''
        Enable Social (Discord, Beeper)
      '';

      utils.enable = mkEnableOption ''
        Enable common GUI Tools
      '';

      ai = {
        lmstudio.enable = mkEnableOption ''
          Enable LMStudio
        '';

        comfyUI.enable = mkEnableOption ''
          Enable ComfyUI (from nix-ai-stuff flake)
        '';
      };
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

        waybarConfig = {
          batteryName = mkOption {
            type = lib.types.string;
            default = "BAT0";
            description = "Battery filename as in /sys/class/powwer_supply/BATx";
          };
        };
      };

      gnome.enable = mkEnableOption ''
        Enable Gnome
      '';

      stylix.enable = mkEnableOption ''
        Enable stylix (if enabled in NixOS config)
      '';
    };

    misc = {
      nextcloud = {
        enable = mkEnableOption ''
          Enable Nextcloud desktop client
        '';
      };
    };
    gaming.enable = mkEnableOption ''
      Enable Gaming
    '';

    virtualization.enable = mkEnableOption ''
      Enable Virtualization
    '';
  };
}
