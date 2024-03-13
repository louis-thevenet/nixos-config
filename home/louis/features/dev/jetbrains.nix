{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.dev;
in {
  home.packages = mkIf cfg.enableJetBrains (with pkgs; [
    jetbrains.rust-rover
    jetbrains.idea-ultimate
    #jetbrains.clion
    #jetbrains.pycharm-professional
  ]);
}
