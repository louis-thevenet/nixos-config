{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ../common/global
    # ../common/optional/services.nix
    # ../common/optional/stylix.nix
    # ../common/optional/niri.nix
    # ../common/optional/kanata.nix
    # ../common/optional/xdg.nix
    # ../common/optional/nix-index.nix
  ];
  networking.hostName = "hermaeus";
  services.usbmuxd.enable = true;

}
