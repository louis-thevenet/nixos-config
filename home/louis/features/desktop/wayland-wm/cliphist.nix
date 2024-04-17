{config, ...}: let
  cfg = config.home-config.desktop;
in {
  services.cliphist.enable = cfg.hyprland.enable;
}
