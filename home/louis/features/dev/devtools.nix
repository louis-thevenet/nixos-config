{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.dev;
in {
  home.packages = mkIf cfg.devTools.enable (with pkgs; [
    screen
    tmux
    tokei
    (
      vale.withStyles
      (s: [s.alex s.proselint s.google s.readability])
    )
  ]);

  home.file.".vale.ini".text = ''
    StylesPath = styles
    MinAlertLevel = suggestion

    Packages = Google, Readability, alex, proselint

    [*]
    BasedOnStyles = alex, proselint
  '';
}
