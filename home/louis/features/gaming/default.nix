{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config;
in
{

  home.packages = mkIf cfg.gaming.enable (
    with pkgs;
    [
      vintagestory
    ]
  );
}
