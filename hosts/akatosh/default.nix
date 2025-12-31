{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ../common/global
    ../common/users/louis
    ../common/optional/services.nix
    ../common/optional/stylix.nix
    ../common/optional/impermanence-disko.nix
    ../common/optional/niri.nix
    ../common/optional/tlp.nix
    ../common/optional/kanata.nix
    ../common/optional/xdg.nix
    ../common/optional/virt.nix
    ../common/optional/howdy-pam.nix
    "${inputs.nixpkgs-howdy}/nixos/modules/services/security/howdy"
    "${inputs.nixpkgs-howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"
  ];
  networking = {
    hostName = "akatosh";
    firewall.allowedTCPPorts = [
      5000
    ];
  };
  # Keep TTY login password-only for security
  security.pam.services = {
    login.howdyAuth = lib.mkForce false;
    # Enable Howdy for sudo and other graphical/convenience authentications
    sudo.howdyAuth = true;
    polkit-1.howdyAuth = true;
  };

  programs = {
    steam.enable = true;
    gamescope.enable = true;
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  hardware = {
    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    graphics.enable = true;
  };
  services = {
    udisks2.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
    howdy = {
      enable = true;
      package = pkgs.howdy;
      settings = {
        core = {
          abort_if_ssh = true;
        };
        video.dark_threshold = 90;
        video.timeout = 2;
      };
    };

    linux-enable-ir-emitter = {
      enable = true;
      package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.linux-enable-ir-emitter;
    };
  };
}
