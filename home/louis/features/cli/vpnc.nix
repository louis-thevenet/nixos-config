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
  home.packages = mkIf cfg.VPNC.enable (
    with pkgs;
    [
      vpnc
    ]
  );
}
