{pkgs, ...}: {
  home.packages = with pkgs; [
    anytype
    bitwarden
    calibre
    libsForQt5.okular
    tigervnc
    tor-browser-bundle-bin
    onlyoffice-bin
    filezilla
  ];
}
