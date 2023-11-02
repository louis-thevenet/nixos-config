{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./locale.nix
    ./nix.nix
  ];
  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
    };
  };

  networking.networkmanager.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.zsh.enable = true;

  console.keyMap = "fr";
  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      layout = "fr";
      desktopManager.gnome = {
        enable = true;
      };
      displayManager.gdm = {
        enable = true;
      };
    };
  };

  services.xserver.libinput.enable = true;

  environment.systemPackages = with pkgs; [vim];
  services.blueman.enable = true;

  system.stateVersion = "23.05";
}
