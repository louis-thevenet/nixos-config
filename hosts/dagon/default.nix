{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ./nextcloud.nix
    ./glance.nix
    ./anubis.nix
    ./jellyfin.nix
    ./nginx.nix
    ./karakeep.nix
    ./restic.nix
    ./adguardhome.nix
    ./hugo.nix
    ../common/global/nix.nix
    ../common/global/locale.nix
    ../common/users/louis
    ../common/optional/stylix.nix
  ];
  networking.hostName = "dagon";
  programs.fish.enable = true;
  programs.dconf.enable = true;
  console.keyMap = "fr";

  environment.etc."NetworkManager/dispatcher.d/10-disable-wifi-when-ethernet".source =
    pkgs.writeScript "disable-wifi-when-ethernet" ''
      #!${pkgs.bash}/bin/bash
      interface="$1"
      status="$2"

      if [[ "$interface" == "end0" ]]; then
        case "$status" in
          up)
            # Ethernet => no wifi
            ${pkgs.networkmanager}/bin/nmcli radio wifi off
            ;;
          down)
            # No ethernet => wifi
            ${pkgs.networkmanager}/bin/nmcli radio wifi on
            ;;
        esac
      fi
    '';

  security.rtkit.enable = true;
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };
  services.openssh = {
    enable = true;
    ports = [ 22 ];
  };
  documentation.man.generateCaches = false;
  system.stateVersion = "24.11";

}
