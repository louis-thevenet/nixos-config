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

  console.keyMap = "fr";

  services.libinput.enable = true;

  security.rtkit.enable = true;
  environment.systemPackages = with pkgs; [ vim ];

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  system.stateVersion = "24.11";

}
