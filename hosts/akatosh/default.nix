{ pkgs, inputs, ... }:
{
  disabledModules = [ "security/pam.nix" ];
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ../common/global
    ../common/optional/services.nix
    ../common/optional/impermanence-disko.nix
    ../common/optional/niri.nix
    ../common/optional/tlp.nix
    ../common/optional/kanata.nix
    ../common/optional/xdg.nix
    ../common/optional/stylix.nix
    "${inputs.nixpkgs-howdy}/nixos/modules/security/pam.nix"
    "${inputs.nixpkgs-howdy}/nixos/modules/services/security/howdy"
    "${inputs.nixpkgs-howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"
  ];
  networking.hostName = "akatosh";
  networking.firewall.allowedTCPPorts = [
    5000
  ];
  programs.steam.enable = true;
  programs.gamescope.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  hardware = {
    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    graphics.enable = true;
  };
  nixpkgs.overlays = [
    (
      let
        pkgs-howdy = inputs.nixpkgs-howdy.legacyPackages."x86_64-linux";
      in
      _: _: {
        inherit (pkgs-howdy) howdy;
      }

    )
  ];
  security.pam.services.login.howdyAuth = false;
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
