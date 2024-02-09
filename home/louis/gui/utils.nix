{pkgs, ...}: {
  home.packages = with pkgs; [
    bitwarden
    calibre
    libsForQt5.okular
    tigervnc
    tor-browser-bundle-bin
    onlyoffice-bin
    filezilla
    obs-studio
    cinnamon.nemo
  ];
}
