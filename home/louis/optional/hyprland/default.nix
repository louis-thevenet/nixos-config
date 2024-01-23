{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./window-binds.nix
    ./binds.nix
  ];
  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;

    settings = {
      input = {
        kb_layout = "fr,us";
        numlock_by_default = true;
        touchpad = {
          disable_while_typing = false;
          natural_scroll = true;
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      misc = {
        mouse_move_enables_dpms = true;
        enable_swallow = true;
        swallow_regex = "^(kitty)$";
        vfr = "on";
        focus_on_activate = true;
      };
    };
  };
}
