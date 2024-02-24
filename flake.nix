{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-colors.url = "github:misterio77/nix-colors";

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.34.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    schizofox.url = "github:schizofox/schizofox/main";
  };

  outputs = {
    self,
    nixpkgs,
    sops-nix,
    home-manager,
    nix-colors,
    ...
  }: let
    forEachSystem = nixpkgs.lib.genAttrs ["aarch64-linux" "x86_64-linux"];
    forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});

    mkNixos = host: system:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit (self) inputs outputs;};
        modules = [
          ./hosts/${host}
        ];
      };

    mkHome = host: system:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          inherit (self) inputs outputs;
          inherit nix-colors;
        };
        modules = [
          ./home/louis/${host}.nix
        ];
      };
  in {
    formatter = forEachPkgs (pkgs: pkgs.alejandra);

    nixosConfigurations = {
      raspberrypi = mkNixos "raspberrypi" "aarch64-linux";
      magnus = mkNixos "magnus" "x86_64-linux";
      hircine = mkNixos "hircine" "x86_64-linux";
      iso = mkNixos "iso" "x86_64-linux";
    };

    homeConfigurations = {
      "louis@magnus" = mkHome "magnus" "x86_64-linux";
      "louis@hircine" = mkHome "hircine" "x86_64-linux";
      "louis@raspberrypi" = mkHome "raspberrypi" "aarch64-linux";
      "louis@iso" = mkHome "iso" "x86_64-linux";
    };
  };
}
