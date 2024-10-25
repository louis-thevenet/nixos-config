{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config;
in
{
  home.packages = mkIf cfg.virtualization.enable (
    with pkgs;
    [
      qemu
      virt-manager
    ]
  );

  dconf.settings = mkIf cfg.virtualization.enable {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
