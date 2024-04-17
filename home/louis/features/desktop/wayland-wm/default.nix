{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
in {
  imports = [
    ./swaync.nix
    ./waybar.nix
    ./rofi.nix
    ./copyq.nix
    ./hyprlock.nix
    ./hypridle.nix
  ];
  home.packages = mkIf cfg.hyprland.enable (with pkgs; [
    meson
    wayland-protocols
    wayland-utils
    wlroots
    swww
  ]);

  services.playerctld.enable = cfg.hyprland.enable;
}
