{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.virtualization;
in {
  home.packages = mkIf cfg.enableVirtualization (with pkgs; [
    qemu
    virt-manager
  ]);

  dconf.settings = mkIf cfg.enableVirtualization {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
