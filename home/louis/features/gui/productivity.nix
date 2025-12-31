{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.gui;
in
{
  home.packages = mkIf cfg.utils.enable (with pkgs; [ onlyoffice-desktopeditors ]);
}
