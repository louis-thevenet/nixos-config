{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./global
    ./gui
    ./cli
  ];
}
