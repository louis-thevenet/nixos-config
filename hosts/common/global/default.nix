{ pkgs, ... }:
{
  imports = [
    ./locale.nix
    ./nix.nix
  ];
  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.fish.enable = true;

  console.keyMap = "fr";

  services.libinput.enable = true;

  security.rtkit.enable = true;
  environment.systemPackages = with pkgs; [ vim ];

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
  documentation.man.generateCaches = false;

  system.stateVersion = "24.11";
}
