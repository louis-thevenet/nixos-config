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
      beeper
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
          "plugins_order" = [
            "rnnoise#0"
          ];

          "rnnoise#0" = {
            bypass = false;
            "enable-vad" = true;
            "input-gain" = 0.0;
            "output-gain" = 0.0;
            release = 100.0;
            "vad-thres" = 90.0;
            wet = 1.0;
          };
        };
      };
    };
  };
}
