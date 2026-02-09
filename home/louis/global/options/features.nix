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
    };
    gui = {
      kitty.enable = mkEnableOption ''
        Enable Kitty
      '';

      firefox = {
        enable = mkEnableOption ''
          Enable Firefox
        '';
        searxngInstance = {
          local = mkEnableOption "Self-host Searxng or not";
          url = mkOption {
            type = lib.types.str;
            default = "https://searxng.brihx.fr";
            description = ''
              URL for searxng instance
            '';
          };
          port = mkOption {
            type = lib.types.int;
            default = 443;
            description = ''
              Port for searxng instance
            '';
          };
        };

        homepageUrl = mkOption {
          type = lib.types.str;
          default = "about:blank";
          description = ''
            URL for firefox homepage
          '';
        };
      };

      social = {
        enable = mkEnableOption ''
          Enable Social (Discord, Beeper)
        '';

        noise_reduction.enable = mkEnableOption ''
          Enable Noise Reduction for microphone (tweaked to my BT headset and keyboard)
        '';
      };
      utils.enable = mkEnableOption ''
        Enable common GUI Tools
      '';

    };
    dev = {
      vscode.enable = mkEnableOption ''
        Enable VsCode
      '';

      devTools.enable = mkEnableOption ''
        Enable common Dev Tools
      '';
      helixAdvancedConfig.enable = mkEnableOption ''
        Enable Helix LSP Config
      '';
    };

    desktop = {
      wayland = {

        enable = mkEnableOption "Enable Wayland Window Manager";
        niri = {
          enable = mkEnableOption "Enable Niri";
          brokenAudioMuteKey = mkEnableOption "How did I even break this";
        };

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
            type = lib.types.str;
            default = "BAT0";
            description = "Battery filename as in /sys/class/powwer_supply/BATx";
          };
        };
      };

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
