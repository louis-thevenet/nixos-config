{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.gui;
in {
  home.packages = mkIf cfg.enableUtils (with pkgs; [
    calibre
    libsForQt5.okular
    tor-browser-bundle-bin
    gnome.nautilus
    spotify
  ]);
}
