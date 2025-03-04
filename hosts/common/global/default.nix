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
  services = {

    printing.enable = true;
    pulseaudio.enable = false;
    gnome.gnome-keyring.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    libinput.enable = true;
    logind.extraConfig = ''
      # don’t shutdown when power button is short-pressed
      HandlePowerKey=ignore
    '';
  };

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

  system.stateVersion = "24.11";
}
