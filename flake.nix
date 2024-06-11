{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    stylix.url = "github:danth/stylix";

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    schizofox.url = "github:schizofox/schizofox/main";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-master,
    home-manager,
    stylix,
    ...
  }: let
    forEachSystem = nixpkgs.lib.genAttrs ["aarch64-linux" "x86_64-linux"];
    forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});

    mkShell = system:
      nixpkgs.legacyPackages.${system}.mkShell {
        packages = with nixpkgs.legacyPackages.${system};
        with pkgs; [
          nil
          alejandra
          python311Packages.nix-prefetch-github
          nixos-generators
          nix-du
          graphviz
          sops
          age
        ];
      };

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
        };
        modules = let
          overlay-master = final: prev: {
            master = import nixpkgs-master {
              system = final.system;
              config.allowUnfree = true;
            };
          };
        in [
          ({
            config,
            pkgs,
            stylix,
            ...
          }: {nixpkgs.overlays = [overlay-master];})

          ./home/louis/${host}.nix
          stylix.homeManagerModules.stylix
        ];
      };
  in {
    formatter = forEachPkgs (pkgs: pkgs.alejandra);
    devShells."x86_64-linux".default = mkShell "x86_64-linux";

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
