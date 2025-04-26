{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ./nextcloud.nix
    ./nginx.nix
    ../common/global/nix.nix
    ../common/global/locale.nix
    # ../common/global
    ../common/users/louis
  ];
  networking.hostName = "dagon";

  programs.fish.enable = true;
  programs.dconf.enable = true;
  console.keyMap = "fr";

  security.rtkit.enable = true;
  environment.systemPackages = with pkgs; [ vim ];

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
      ];
    };

  };
  services.openssh = {
    enable = true;
    ports = [ 22 ];
  };
  documentation.man.generateCaches = false;
  system.stateVersion = "24.11";

}
