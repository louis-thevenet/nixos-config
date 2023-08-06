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
      ];


    };
    "org/gnome/desktop/interface" = {
      enable-hot-corners =
        false;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };


    "org/gnome/shell/extensions/just-perfection" = {
      activities-button = false;
      app-menu = false;
      calendar = false;
      events-button = false;


    };
    "org/gnome/shell/extensions/clipboard-indicator" = { history-size = 100; };

    "org/gnome/shell/extensions/vitals" = { hot-sensors = "['_memory_usage_', '__network-rx_max__', '_processor_usage_']"; };


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
  ];
}
