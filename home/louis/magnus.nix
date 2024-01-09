{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./home-manager.nix
    ./global
    ./gui
    ./cli
    ./dev
    ./optional/gnome.nix
  ];
}
