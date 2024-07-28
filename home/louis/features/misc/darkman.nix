{pkgs, ...}: {
  services.darkman = {
    enable = true;
    darkModeScripts = {
      activate = ''
        /run/current-system/specialisation/dark/activate
        swaync-client -rs # reload CSS for swaync (notification center)
      '';
    };
    lightModeScripts = {
      activate = ''
        /run/current-system/specialisation/light/activate
        swaync-client -rs # reload CSS for swaync (notification center)
      '';
    };
    settings = {
      lat = 48.86;
      lng = 2.35;
      dbusserver = true;
    };
  };
}
