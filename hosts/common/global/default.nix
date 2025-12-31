{ pkgs, lib, ... }:
{
  imports = [
    ./locale.nix
    ./nix.nix
    ./openssh.nix
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
  # Disable Howdy for TTY login by default (can be overridden per-host)
  security.pam.services.login.howdyAuth = lib.mkDefault false;
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

  system.stateVersion = "25.11";
}
