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
    screen
    tmux
    tokei
  ]);
}
