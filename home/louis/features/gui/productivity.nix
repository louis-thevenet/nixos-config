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
    bitwarden
    onlyoffice-bin
    super-productivity
  ]);
}
