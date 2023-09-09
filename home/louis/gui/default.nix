{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./vscode.nix
    ./firefox.nix
    ./kitty.nix
  ];

  home.packages = with pkgs; [
    whatsapp-for-linux
    spotify
    discord
    anytype
    bitwarden
    tor-browser-bundle-bin
    libsForQt5.okular
    betterdiscordctl
    x2goclient
  ];
}
