{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    nixosConfigurations = {
      louisdesktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [ ./nixos/configuration-desktop.nix ];
      };

      louislaptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./nixos/configuration-laptop.nix ];
      };
    };

    homeConfigurations = {
      "louis@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home-manager/home.nix ];
      };
    };
  };
}
