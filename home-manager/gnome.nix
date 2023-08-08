{ config, pkgs, ... }: {
  gtk = {
    enable = true;

    theme = {
      name = "marwaita-pop_os";
      package = pkgs.marwaita-pop_os;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

  };
  home.sessionVariables.GTK_THEME = "marwaita-pop_os";


  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "default";
      enable-hot-corners =
        false;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = "disabled";
      maximize = "disabled";
      minimize = [ "<Super>comma" ];
      move-to-monitor-down = "disabled";
      move-to-monitor-left = "disabled";
      move-to-monitor-right = "disabled";
      move-to-monitor-up = "disabled";
      move-to-workspace-down = "disabled";
      move-to-workspace-up = "disabled";
      unmaximize = "disabled";
      toggle-tiled-left = "disabled";
      toggle-tiled-right = "disabled";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "kitty ctrl alt";
      command = "kitty";
      binding = "<Ctrl><Alt>t";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "kitty super";
      command = "kitty";
      binding = "<Super>t";
    };


    "org/gnome/shell" = {
      disabled-extensions = [
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
      ];

      enabled-extensions = [
        "pop-launcher-super-key@ManeLippert"
        "pop-shell@system76.com"
        "caffeine@patapon.info"
        "just-perfection-desktop@just-perfection"
        "clipboard-indicator@tudmotu.com"
        "mediacontrols@cliffniff.github.com"
        "Vitals@CoreCoding.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "alttab-mod@leleat-on-github"
      ];


    };

    "org/gnome/shell/extensions/pop-shell" = {
      focus-right = "disabled";
      tile-by-default = true;
      tile-enter = "disabled";
    };

    "org/gnome/shell/extensions/just-perfection" = {
      activities-button = false;
      app-menu = false;
      calendar = false;
      events-button = false;
    };
    "org/gnome/shell/extensions/clipboard-indicator" = { history-size = 100; };

    "org/gnome/shell/extensions/vitals" = { hot-sensors = "['_memory_usage_', '__network-rx_max__', '_processor_usage_']"; };

    "altTab-mod" = {
      "disable-hover-select" = true;
      "remove-delay" = true;
    };
  };

  home.packages = with pkgs; [
    pop-launcher
    gnomeExtensions.pop-shell
    gnomeExtensions.pop-launcher-super-key
    gnomeExtensions.caffeine
    gnomeExtensions.just-perfection
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.media-controls
    gnomeExtensions.vitals
    gnomeExtensions.workspace-indicator
    gnomeExtensions.alttab-mod

  ];
}
