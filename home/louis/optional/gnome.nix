{
  config,
  pkgs,
  ...
}: {
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
      enable-hot-corners = false;
      show-battery-percentage = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {accel-profile = "flat";};

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      num-workspaces = 3;
    };

    "org/gnome/desktop/wm/keybindings" = {
      maximize = ["<Super>semicolon"];
      minimize = ["<Super>comma"];
      unmaximize = [];
      toggle-fullscreen = ["F11"];
      move-to-workspace-left = ["<Control><Super>Left"];
      move-to-workspace-right = ["<Control><Super>Right"];
    };
    "org/gnome/mutter/keybindings" = {
      "toggle-tiled-left" = [];
      "toggle-tiled-right" = [];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
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

    "org/gnome/settings-daemon/plugins/power" = {idle-dim = false;};

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
        #"mediacontrols@cliffniff.github.com"
        "Vitals@CoreCoding.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "alttab-mod@leleat-on-github"
        "upower-battery@codilia.com"
        "batterytime@typeof.pw"
        "hidetopbar@mathieu.bidon.ca"
      ];
    };

    "org/gnome/shell/extensions/pop-shell" = {
      focus-right = "disabled";
      tile-by-default = true;
      tile-enter = "disabled";
      active-hint = true;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      activities-button = false;
      app-menu = false;
      calendar = true;
      events-button = false;
      startup-status = 0;
    };

    "org/gnome/shell/extensions/hidetopbar" = {mouse-sensitive = true;};

    "org/gnome/shell/extensions/clipboard-indicator" = {history-size = 100;};

    "org/gnome/shell/extensions/vitals" = {hot-sensors = "['_memory_usage_', '__network-rx_max__', '_processor_usage_']";};

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
    #gnomeExtensions.media-controls
    gnomeExtensions.vitals
    gnomeExtensions.workspace-indicator
    gnomeExtensions.alttab-mod
    gnomeExtensions.upower-battery
    gnomeExtensions.battery-time-2
    gnomeExtensions.hide-top-bar
  ];
}
