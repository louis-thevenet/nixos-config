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
      inputs.vault-tasks.legacyPackages.${pkgs.system}.vault-tasks
      spotify-player
      television
      rbw
      pinentry
      vhs
      transmission_4
      restic
      (mcat.override {
        useFfmpeg = true;
        useChromium = true;
      })
    ]
  );
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };
}
