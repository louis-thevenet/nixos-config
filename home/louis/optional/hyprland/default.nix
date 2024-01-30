{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./window-binds.nix
    ./binds.nix
    ./decoration.nix
  ];
  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    # Whether to enable XWayland
    xwayland.enable = true;
    extraConfig = ''
      exec-once = swww init
      exec-once = swww img ~/bg.png
    '';
    settings = {
      input = {
        kb_layout = "fr,us";
        numlock_by_default = true;
        touchpad = {
          disable_while_typing = false;
          natural_scroll = true;
        };
      };
      monitor =
        map (
          m: let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}";
          in "${m.name},${
            if m.enabled
            then "${resolution},${position},1"
            else "disable"
          }"
        ) (config.monitors)
        ++ [",preferred,auto,1"];

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
