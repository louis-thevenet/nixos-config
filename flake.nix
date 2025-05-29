{
  description = "NixOS config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
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
      url = "github:danth/stylix";
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

    schizofox = {
      url = "github:schizofox/schizofox/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wakatime-lsp = {
      url = "github:mrnossiom/wakatime-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xdp-termfilepickers = {
      url = "github:Guekka/xdg-desktop-portal-termfilepickers";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ai-stuff = {
      url = "github:BatteredBunny/nix-ai-stuff";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vault-tasks = {
      url = "github:louis-thevenet/vault-tasks";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blog = {
      url = "git:/home/louis/src/blog";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      # nixpkgs-master,
      home-manager,
      stylix,
      niri,
      git-hooks-nix,
      nix-index-database,
      nixos-hardware,
      ...
    }:
    let
      forEachSystem = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
      ];
      forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
      mkChecks = system: {
        pre-commit-check = git-hooks-nix.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt-rfc-style = {
              enable = false;
              settings.width = 110;
            };
            deadnix.enable = true;
            statix.enable = true;
          };
        };
      };

      mkShell =
        system:
        nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          # buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
          packages =
            with nixpkgs.legacyPackages.${system};
            with pkgs;
            [
              nil
              statix
              python311Packages.nix-prefetch-github
              nixos-generators
              # nix-du
              graphviz
              sops
              age
              deadnix
            ]
            ++ [
              pkgs.home-manager
            ];
        };

      mkNixos =
        user: host: system: specific-modules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit (self) inputs outputs;
          };
          modules =
            # let
            #   overlay-master = prev: final: {
            #     master = import nixpkgs-master {
            #       inherit prev final system;
            #       config.allowUnfree = true;
            #     };
            #   };
            # in
            [
              ./hosts/${host}
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  users.${user} = import ./home/${user}/${host}.nix;
                  backupFileExtension = "backup_hm";
                  extraSpecialArgs = {
                    inherit (self) inputs outputs;
                  };
                };
              }

              stylix.nixosModules.stylix
              nix-index-database.nixosModules.nix-index
              {
                programs.nix-index-database.comma.enable = true;
                programs.nix-index.enable = true;
              }
            ] ++ specific-modules;
        };
    in
    {
      nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
      formatter = forEachPkgs (pkgs: pkgs.nixfmt-rfc-style);

      checks."x86_64-linux" = mkChecks "x86_64-linux";
      devShells."x86_64-linux".default = mkShell "x86_64-linux";

      checks."aarch64-linux" = mkChecks "aarch64-linux";
      devShells."aarch64-linux".default = mkShell "aarch64-linux";

      nixosConfigurations = {
        magnus = mkNixos "louis" "magnus" "x86_64-linux" [
          (_: {
            nixpkgs.overlays = [
              niri.overlays.niri
            ];

          })
          niri.nixosModules.niri
        ];
        akatosh = mkNixos "louis" "akatosh" "x86_64-linux" [
          (_: {
            nixpkgs.overlays = [
              niri.overlays.niri
            ];

          })
          niri.nixosModules.niri
        ];
        dagon = mkNixos "louis" "dagon" "aarch64-linux" [
          nixos-hardware.nixosModules.raspberry-pi-4
        ];
      };
    };
}
