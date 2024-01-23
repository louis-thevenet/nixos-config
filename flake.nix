{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    raspberry-pi-nix.url = "github:tstat/raspberry-pi-nix";

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixos-hardware,
    raspberry-pi-nix,
    nix-colors,
    ...
  } @ inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixpkgs-fmt;

    nixosConfigurations = {
      magnus = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [./hosts/magnus];
      };
      hircine = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/hircine
          nixos-hardware.nixosModules.lenovo-ideapad-15arh05
          nixos-hardware.nixosModules.common-cpu-amd-pstate
        ];
      };

      raspberrypi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "aarch64-linux";
        modules = [
          raspberry-pi-nix.nixosModules.raspberry-pi
          (import ./hosts/raspberrypi)
        ];
      };
    };

    homeConfigurations = {
      "louis@magnus" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit nix-colors;
          inherit inputs;
        };
        modules = [./home/louis/magnus.nix];
      };
      "louis@hircine" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [./home/louis/hircine.nix];
      };

      "louis@raspberrypi" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./home/louis/raspberrypi.nix
        ];
      };
    };
  };
}
