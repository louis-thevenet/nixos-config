{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.gui;
in {
  home.packages = mkIf cfg.enableSocial (with pkgs; [
    whatsapp-for-linux
    discord
  ]);
}
