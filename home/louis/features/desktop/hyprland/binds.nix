{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings.binde = let
    brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
    pactl = "${pkgs.pulseaudio}/bin/pactl";
  in [
    # Brightness
    ",XF86MonBrightnessUp,exec,${brightnessctl} set +5%"
    ",XF86MonBrightnessDown,exec,${brightnessctl} set 5%-"
    # Volume
    ",XF86AudioRaiseVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
    ",XF86AudioLowerVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
    "SHIFT,XF86AudioRaiseVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ +1%"
    "SHIFT,XF86AudioLowerVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ -1%"
    ",XF86AudioMute,exec,${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
    "SHIFT,XF86AudioMute,exec,${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
    ",XF86AudioMicMute,exec,${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
  ];

  wayland.windowManager.hyprland.settings.bind = let
    swaylock = "${config.programs.swaylock.package}/bin/swaylock";
    swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
    grimblast = "${pkgs.grimblast}/bin/grimblast";
    terminal = config.home.sessionVariables.TERMINAL;
    killall = "${pkgs.killall}/bin/killall";
  in
    [
      "SUPER,T,exec,${terminal}"

      "SUPER, C, exec, copyq show" # Clipboard manager
      "SUPER, V, exec, copyq select 1" # Copy last clipboard entry

      # Screenshotting
      ",Print,exec,${grimblast} --notify copy area"
      "ALT,Print,exec,${grimblast} --notify save area"
      "SHIFT,Print,exec,${grimblast} --notify copy active"
      "CONTROL,Print,exec,${grimblast} --notify copy screen"
      "SUPER,Print,exec,${grimblast} --notify copy window"
    ]
    # Launcher
    ++ [
      "SUPER,x,exec,rofi -show drun -sidebar-mode"
      "SUPERSHIFT,x,exec,rofi -show run"
      "SUPER,tab,exec,rofi -show window"
    ]
    # Waybar
    ++ [
      "SUPERSHIFT,w,exec,${killall} -SIGUSR1 .waybar-wrapped"
    ]
    ++
    # Screen lock
    (lib.optionals config.programs.swaylock.enable [
      ",XF86Launch5,exec,${swaylock}"
      ",XF86Launch4,exec,${swaylock}"
      "SUPER,backspace,exec,${swaylock}"
    ])
    ++
    # Notification manager
    [
      "SUPER,w,exec,${swaync-client} -t" # cp closes
    ]
    ++
    # Bluetooth
    [
      "SUPER,p,exec,blueman-manager"
    ];
}
