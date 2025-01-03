{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
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

  networking.networkmanager.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.zsh.enable = true;

  console.keyMap = "fr";
  services.printing.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;
  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  environment.systemPackages = with pkgs; [ vim ];
  services.blueman.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 8080;
        to = 8100;
      }
    ];
  };

  system.stateVersion = "24.11";
}
