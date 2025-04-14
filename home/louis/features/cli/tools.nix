{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.cli;
in
{
  home.packages = mkIf cfg.commonTools.enable (
    with pkgs;
    [
      neofetch
      eza
      bat
      trash-cli
      du-dust
      git-open
      nix-output-monitor
      noti
      nm-tray
      killall
      wget
      tdf
      see-cat
      smartcat
      inputs.vault-tasks.packages.${pkgs.system}.default
      spotify-player
      television
      rbw
      pinentry
      vhs
    ]
  );
}
