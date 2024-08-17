{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.cli;
in {
  home.packages = mkIf cfg.commonTools.enable (with pkgs; [
    neofetch
    eza
    bat
    trash-cli
    du-dust
    git-open
    noti
    nm-tray
    killall
    yazi
    wget
  ]);
}
