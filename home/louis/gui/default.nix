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
    anytype
    bitwarden
    tor-browser-bundle-bin
    discord
    libsForQt5.okular
    betterdiscordctl
  ];
}
