{config, ...}: let
  cfg = config.home-config.desktop;
in {
  services.copyq.enable = cfg.hyprland.enable;
}
