{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg-social = config.home-config.gui;
in
{
  home.packages = mkIf cfg-social.social.enable (
    with pkgs;
    [
      master.beeper
      discord
    ]
  );
}
