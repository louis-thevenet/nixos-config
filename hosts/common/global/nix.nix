{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      cores = 4;
    };
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 3 --keep-since 7d";
    };
    flake = /home/louis/src/nixos-config;
  };
}
