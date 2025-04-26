{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
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
    firewall.enable = true;
  };
  services.openssh = {
    enable=true;
    ports = [22];
  };
  system.stateVersion = "24.11";

}
