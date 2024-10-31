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
      dysk
      broot
      trash-cli
      du-dust
      git-open
      noti
      nm-tray
      killall
      wget
      comma
      tdf
      see-cat
      inputs.vault-tasks.packages.${pkgs.system}.default
      vhs
    ]
  );
  programs.fzf.enable = cfg.commonTools.enable;
}
