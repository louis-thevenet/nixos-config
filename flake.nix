{
  description = "NixOS config";
  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-howdy.url = "github:fufexan/nixpkgs/howdy";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wakatime-lsp = {
      url = "github:mrnossiom/wakatime-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ai-stuff = {
      url = "github:BatteredBunny/nix-ai-stuff";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blog.url = "git+file:/home/louis/src/blog";

    helix = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "github:helix-editor/helix";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
      ];
      forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});

      mkShell =
        system:
        nixpkgs.legacyPackages.${system}.mkShell {
          packages =
            with nixpkgs.legacyPackages.${system};
            with pkgs;
            [
              python311Packages.nix-prefetch-github
              sops
              age
              just
            ]
            ++ [ pkgs.home-manager ];
        };
      mkNixosNew =
        host: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit (self) inputs outputs; };
          modules = [
            ./hosts/${host}
          ];
        };

      mkHomeNew =
        host: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit (self) inputs outputs; };
          modules = [
            ./home/louis/${host}.nix
          ];
        };
      # mkNixos =
      #   user: host: system: specific-modules:
      #   nixpkgs.lib.nixosSystem {
      #     inherit system;
      #     specialArgs = {
      #       inherit (self) inputs outputs;
      #     };
      #     modules = [
      #       ./hosts/${host}
      #       home-manager.nixosModules.home-manager
      #       {
      #         home-manager = {
      #           users.${user} = import ./home/${user}/${host}.nix;
      #           backupFileExtension = "backup_hm";
      #           extraSpecialArgs = {
      #             inherit (self) inputs outputs;
      #           };
      #           sharedModules = [
      #             sops-nix.homeManagerModules.sops
      #           ];
      #         };
      #       }
      #       stylix.nixosModules.stylix
      #       nix-index-database.nixosModules.nix-index
      #       {
      #         programs.nix-index-database.comma.enable = true;
      #         programs.nix-index.enable = true;
      #       }
      #     ]
      #     ++ specific-modules;
      #   };
    in
    {
      nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
      formatter = forEachPkgs (pkgs: pkgs.nixfmt-rfc-style);

      devShells."x86_64-linux".default = mkShell "x86_64-linux";
      devShells."aarch64-linux".default = mkShell "aarch64-linux";

      #   nixosConfigurations = {
      #     magnus = mkNixos "louis" "magnus" "x86_64-linux" [
      #       (_: {
      #         nixpkgs.overlays = [
      #           niri.overlays.niri
      #         ];

      #       })
      #       niri.nixosModules.niri
      #     ];
      #     akatosh = mkNixos "louis" "akatosh" "x86_64-linux" [
      #       (_: {
      #         nixpkgs.overlays = [
      #           (
      #             let
      #               pkgs-howdy = nixpkgs-howdy.legacyPackages."x86_64-linux";
      #             in
      #             _: _: {
      #               inherit (pkgs-howdy) howdy;
      #             }

      #           )
      #           niri.overlays.niri
      #         ];

      #       })
      #       niri.nixosModules.niri
      #     ];
      #     arkay = mkNixos "louis" "arkay" "x86_64-linux" [
      #       (_: {
      #         nixpkgs.overlays = [
      #           niri.overlays.niri
      #         ];

      #       })
      #       niri.nixosModules.niri
      #     ];
      #     dagon = mkNixos "louis" "dagon" "aarch64-linux" [
      #       nixos-hardware.nixosModules.raspberry-pi-4
      #     ];
      #   };
      packages = forEachPkgs (pkgs: import ./pkgs { inherit pkgs; });
      nixosModules = import ./modules/nixos;
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {
        akatosh = mkNixosNew "akatosh" "x86_64-linux";
        magnus = mkNixosNew "magnus" "x86_64-linux";
        dagon = mkNixosNew "dagon" "aarch64-linux";
      };

      homeConfigurations = {
        "louis@akatosh" = mkHomeNew "akatosh" "x86_64-linux";
        "louis@magnus" = mkHomeNew "magnus" "x86_64-linux";
        "louis@dagon" = mkHomeNew "dagon" "aarch64-linux";
      };
    };
}
