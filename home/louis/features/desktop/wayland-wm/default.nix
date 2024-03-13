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
    ./swayidle.nix
    ./swaylock.nix
    ./rofi.nix
    ./copyq.nix
  ];
  home.packages = mkIf cfg.hyprland.enable (with pkgs; [
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
    swww
  ]);
  services.playerctld.enable = cfg.hyprland.enable;
}
