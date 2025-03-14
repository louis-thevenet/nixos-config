{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg-social = config.home-config.gui;
  cfg-wayland = config.home-config.desktop.wayland;

  beeper-wayland = pkgs.symlinkJoin {
    name = "beeper";
    paths = [
      pkgs.beeper
    ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/beeper --add-flags "--ozone-platform=wayland"
    '';
  };
in
{
  home.packages = mkIf cfg-social.social.enable (
    with pkgs;
    [
      (if cfg-wayland.enable then beeper-wayland else pkgs.beeper)
      discord
    ]
  );
}
