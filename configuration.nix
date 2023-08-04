{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users.louis = {
    isNormalUser = true;
    description = "louis thevenet";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      nil
      nixpkgs-fmt
      neofetch
      dotnet-sdk_8
      libgccjit
    ];
  };


  environment.systemPackages = with pkgs; [ ];

  system.stateVersion = "23.05";

  nixpkgs.config.allowUnfree = true;
  #nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };



  home-manager.users.louis.programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;


      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      mutableExtensionsDir = false;



      extensions = with pkgs.vscode-extensions; [
        matklad.rust-analyzer
        ms-dotnettools.csharp
        rust-lang.rust-analyzer
        ms-vscode.cpptools
        jnoortheen.nix-ide
      ]; #++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [ 
      #{
      #  name = "nunjucks-template";
      #  publisher = "eseom";
      #  version = "0.5.1";
      #  sha256 = "CkHPyLZMtyLmqEzRMBqjxHV51R3AYrt8RJ5JQN1egWI=";
      #}
      #];

      userSettings = {

        "editor.formatOnSave" = true;

        "editor.indent_style" = "space";
        "editor.indentSize" = 4;
        "editor.tabSize" = 4;

        "editor.insertSpaces" = true;
        "editor.detectIndentation" = false;

        "workbench.colorTheme" = "Default Light+";
        "workbench.iconTheme" = "ayu";

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.formatterPath" = "nixpkgs-fmt";
        "nix.serverSettings" = {
          "nil" = {
            "formatting" = { "command" = [ "nixpkgs-fmt" ]; };
          };
        };
        "git.enableCommitSigning" = true;
      };
    };
  };

}
