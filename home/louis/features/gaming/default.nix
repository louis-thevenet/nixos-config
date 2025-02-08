{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config;
in
{
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-7.0.20"
  ];
  home.packages = mkIf cfg.gaming.enable (
    with pkgs;
    [
      vintagestory
    ]
  );
}
