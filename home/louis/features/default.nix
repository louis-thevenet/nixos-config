{...}: {
  # Default config -> adds Hyprland + common tools
  imports = [
    ./cli
    ./gui
    ./desktop/hyprland
    ./desktop/wayland-wm
    ./dev
  ];
}
