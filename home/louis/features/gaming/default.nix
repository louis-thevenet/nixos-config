{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.gaming;
in {
  home.packages = mkIf cfg.enableGaming (with pkgs; [
    steam
    prismlauncher
    # lutris
    # wine
    # heroic
    # goverlay
    # mangohud
  ]);
}
