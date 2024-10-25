{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ../common/global
    ../common/users/louis
    ../common/optional/stylix.nix
    ../common/optional/impermanence-disko.nix
    ../common/optional/ollama.nix
    ../common/optional/hyprland.nix
    ../common/optional/tlp.nix
  ];
  networking.hostName = "akatosh";

  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  programs.steam.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.udisks2.enable = true;
  hardware.graphics.enable = true;

  # Move this to common/optional once it's merged
  services = {
    howdy = {
      enable = true;
      package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.howdy;
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
