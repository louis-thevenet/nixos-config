{
  config,
  lib,
  pkgs,
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
      bat
      trash-cli
      dust
      git-open
      nix-output-monitor
      noti
      killall
      wget
      tdf
      see-cat
      rsync
      smartcat
      master.vault-tasks
      spotify-player
      television
      rbw
      vhs
      transmission_4
      restic
      todoist
    ]
  );
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };
}
