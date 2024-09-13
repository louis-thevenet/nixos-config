{
  config,
  lib,
  pkgs,
  inputs,
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
    wget
    comma
    tdf
    (callPackage ./see-cat.nix {})
    inputs.vault-tasks.packages.${pkgs.system}.default
  ]);
  programs.fzf.enable = cfg.commonTools.enable;
}
