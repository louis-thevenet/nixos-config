{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.cli;
in {
  home.packages = mkIf cfg.enableCommonTools (with pkgs; [
    neofetch
    eza
    bat
    trash-cli
    du-dust
    git-open
    magic-wormhole
    noti
    nm-tray
    killall
    wget
    nvtop
  ]);
}
