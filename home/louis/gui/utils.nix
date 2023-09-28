{pkgs, ...}: {
  home.packages = with pkgs; [
    anytype
    bitwarden
    tor-browser-bundle-bin
    libsForQt5.okular
    x2goclient
    calibre
  ];
}
