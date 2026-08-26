{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.home-config.desktop.wayland;
in
{
  home = {
    username = "louis";
    homeDirectory = "/home/louis";
  };

  gtk = lib.mkIf cfg.enable {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.sessionVariables.GTK_THEME = lib.mkIf cfg.enable "marwaita-pop_os";
  home.sessionVariables.TERMINAL = "kitty";
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
