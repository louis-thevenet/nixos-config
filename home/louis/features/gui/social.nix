{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg-social = config.home-config.gui;
in
{
  home.packages = mkIf cfg-social.social.enable (
    with pkgs;
    [
      element-desktop
      discord
    ]
  );

  services.easyeffects = mkIf cfg-social.social.noise_reduction.enable {
    enable = true;
    preset = "noise_reduction";
    extraPresets = {
      noise_reduction = {
        input = {
          blocklist = [ ];
          plugins_order = [
            "rnnoise#0"
          ];

          "rnnoise#0" = {
            bypass = false;
            "enable-vad" = true;
            "input-gain" = 0.0;
            "output-gain" = 0.0;
            release = 50.0;
            "vad-thres" = 80.0;
            wet = 1.0;
          };
        };
      };

      noise_reduction_aggressive = {
        input = {
          blocklist = [ ];
          plugins_order = [
            "rnnoise#0"
            "expander#0"
          ];

          "rnnoise#0" = {
            bypass = false;
            "enable-vad" = true;
            release = 50.0;
            "vad-thres" = 95.0;
            wet = 1.0;
          };

          "expander#0" = {
            bypass = false;
            attack = 10.0;
            release = 50.0;
            ratio = 1.5;
            threshold = -40.0;
          };
        };
      };
    };
  };
}
