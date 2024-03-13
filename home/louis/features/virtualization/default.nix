{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.virtualization;
in {
  home.packages = mkIf cfg.Virtualization.enable (with pkgs; [
    qemu
    virt-manager
  ]);

  dconf.settings = mkIf cfg.Virtualization.enable {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
