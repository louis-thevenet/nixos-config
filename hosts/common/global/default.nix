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
    ./services/airpods-battery-fetcher.nix
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gedit # text editor
      epiphany # web browser
      geary # email reader
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      yelp # Help view
      gnome-contacts
      gnome-initial-setup
    ]);

  services.xserver = {
    layout = "fr";
    xkbVariant = "azerty";
  };
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

  services.xserver.libinput.enable = true;

  environment.systemPackages = with pkgs; [vim];
  services.blueman.enable = true;

  system.stateVersion = "23.05";
}
