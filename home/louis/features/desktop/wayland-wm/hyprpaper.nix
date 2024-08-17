{config, ...}: let
  cfg = config.home-config.desktop;
in {
  services.hyprpaper.enable = cfg.hyprland.enable;
}
