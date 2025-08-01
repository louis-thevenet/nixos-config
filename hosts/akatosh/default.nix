{ pkgs, inputs, ... }:
{
  disabledModules = [ "security/pam.nix" ];
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ../common/global
    ../common/users/louis
    ../common/optional/services.nix
    ../common/optional/stylix.nix
    ../common/optional/impermanence-disko.nix
    ../common/optional/ollama.nix
    ../common/optional/niri.nix
    ../common/optional/tlp.nix
    ../common/optional/kanata.nix
    ../common/optional/xdg.nix
    ../common/optional/virt.nix
    "${inputs.nixpkgs-howdy}/nixos/modules/security/pam.nix"
    "${inputs.nixpkgs-howdy}/nixos/modules/services/security/howdy"
    "${inputs.nixpkgs-howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"
  ];
  networking.hostName = "akatosh";
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    secretKeyFile = "/home/louis/cache-priv-key.pem";
  };

  networking.firewall.allowedTCPPorts = [
    5000
  ];
  programs.steam.enable = true;
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
