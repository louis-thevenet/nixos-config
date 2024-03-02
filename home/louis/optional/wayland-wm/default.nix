{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./swaync.nix
    ./waybar.nix
    ./swayidle.nix
    ./swaylock.nix
    ./rofi.nix
    ./copyq.nix
  ];
  home.packages = with pkgs; [
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
    swww
  ];
  services.playerctld.enable = true;
}
