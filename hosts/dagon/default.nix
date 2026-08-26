{
  inputs,
  outputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ../common/global/nix.nix
    ../common/global/nixpkgs.nix
    ../common/global/user.nix
    ../common/global/openssh.nix
    ../common/global/locale.nix
    ../common/optional/stylix.nix
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];
  networking.hostName = "dagon";

  programs.fish.enable = true;
  programs.dconf.enable = true;
  console.keyMap = "fr";

  security.rtkit.enable = true;
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };
  documentation.man.generateCaches = false;
  system.stateVersion = "26.05";

}
