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
    ",XF86AudioMute,exec,${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
    "SHIFT,XF86AudioMute,exec,${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
    ",XF86AudioMicMute,exec,${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
  ];

  wayland.windowManager.hyprland.settings.bind = let
    swaylock = "${config.programs.swaylock.package}/bin/swaylock";
    playerctl = "${config.services.playerctld.package}/bin/playerctl";
    playerctld = "${config.services.playerctld.package}/bin/playerctld";
    makoctl = "${config.services.mako.package}/bin/makoctl";
    wofi = "${config.programs.wofi.package}/bin/wofi";
    pass-wofi = "${pkgs.pass-wofi.override {
      pass = config.programs.password-store.package;
    }}/bin/pass-wofi";

    grimblast = "${pkgs.grimblast}/bin/grimblast";
    # TODO tly = "${pkgs.tly}/bin/tly";
    # gtk-play = "${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play";
    # notify-send = "${pkgs.libnotify}/bin/notify-send";

    gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
    xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
    defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";

    terminal = config.home.sessionVariables.TERMINAL;
    browser = defaultApp "x-scheme-handler/https";
    editor = defaultApp "text/plain";
  in
    [
      "SUPER,T,exec,kitty"

      "SUPER, C, exec, copyq show" # Clipboard manager
      "SUPER, V, exec, copyq select 1" # Copy last clipboard entry

      # Screenshotting
      ",Print,exec,${grimblast} --notify copy area"
      "SHIFT,Print,exec,${grimblast} --notify copy active"
      "CONTROL,Print,exec,${grimblast} --notify copy screen"
      "SUPER,Print,exec,${grimblast} --notify copy window"
      "ALT,Print,exec,${grimblast} --notify copy output"
    ]
    # Launcher
    ++ lib.optionals config.programs.wofi.enable [
      "SUPER,x,exec,${wofi} -S drun -x 10 -y 10 -W 25% -H 60%"
      "SUPER,space,exec,${wofi} -S run"
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
    (lib.optionals config.services.mako.enable [
      "SUPER,w,exec,${makoctl} dismiss"
    ]);
}
