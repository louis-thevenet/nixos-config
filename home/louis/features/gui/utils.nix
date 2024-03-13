{pkgs, ...}: {
  home.packages = with pkgs; [
    calibre
    libsForQt5.okular
    tor-browser-bundle-bin
    gnome.nautilus
    spotify
  ];
}
