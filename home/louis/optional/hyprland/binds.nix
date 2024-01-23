{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings.bind = [
    "SUPER,T,exec,kitty"
  ];
}
