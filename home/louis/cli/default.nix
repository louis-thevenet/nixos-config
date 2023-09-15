{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./optional/vpnc.nix
    ./utils.nix
  ];
}
