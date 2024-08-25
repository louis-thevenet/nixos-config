{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.dev;
in {
  home.packages = mkIf cfg.devTools.enable (with pkgs; [
    tokei
  ]);

  programs.tmux = mkIf cfg.devTools.enable {
    enable = true;
    clock24 = true;
    extraConfig = ''
      set -s escape-time 0
    '';
    prefix = "C-a";
    baseIndex = 1;
  };
}
