{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg-social = config.home-config.gui;
  beeper = pkgs.callPackage ./beeper-beta.nix { };
in
{
  home.packages = mkIf cfg-social.social.enable (
    with pkgs;
    [
      beeper
      discord
    ]
  );
}
