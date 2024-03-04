{pkgs, ...}: {
  home.packages = with pkgs; [
    bitwarden
    calibre
    libsForQt5.okular
    tor-browser-bundle-bin
    onlyoffice-bin
    gnome.nautilus
    warp-terminal
    super-productivity
  ];
}
