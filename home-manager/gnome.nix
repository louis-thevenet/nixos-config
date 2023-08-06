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
      favorite-apps = [ "firefox.desktop" "codium.desktop" "org.gnome.Console.desktop" ];

      disabled-extensions = [
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
      ];



      enabled-extensions = [
        "pop-launcher-super-key@ManeLippert"
        "pop-shell@system76.com"
        "caffeine@patapon.info"
        "just-perfection-desktop@just-perfection"
      ];


    };
    "org/gnome/desktop/interface" = {
      enable-hot-corners =
        false;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };


    # Just-perfection settings
    "org/gnome/shell/extensions/just-perfection" = {
      activities-button = false;
      app-menu = false;
      calendar = false;
      events-button = false;
    };

  };

  home.packages = with pkgs; [
    pop-launcher
    gnomeExtensions.pop-shell
    gnomeExtensions.pop-launcher-super-key
    gnomeExtensions.caffeine
    gnomeExtensions.just-perfection
  ];
}
