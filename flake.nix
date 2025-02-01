{
  description = "NixOS config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:Guekka/helix/copilot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    patchy = {
      url = "github:nik-rev/patchy";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Why is this not on nixpkgs yet ?
    hyprland-qtutils = {
      url = "github:hyprwm/hyprland-qtutils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
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

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-master,
      home-manager,
      stylix,
      nix-index-database,
      ...
    }:
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
              nil
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
        user: host: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit (self) inputs outputs;
          };
          modules =
            let
              overlay-master = final: prev: {
                master = import nixpkgs-master {
                  system = final.system;
                  config.allowUnfree = true;
                };
              };
            in
            [
              ./hosts/${host}
              home-manager.nixosModules.home-manager
              {
                home-manager.users.${user} = import ./home/${user}/${host}.nix;
                home-manager.backupFileExtension = "backup_hm";
                home-manager.extraSpecialArgs = {
                  inherit (self) inputs outputs;
                };
              }
              stylix.nixosModules.stylix
              (
                {
                  ...
                }:
                {
                  nixpkgs.overlays = [ overlay-master ];
                }
              )
              nix-index-database.nixosModules.nix-index
              {
                programs.nix-index-database.comma.enable = true;
                programs.nix-index.enable = true;
              }
            ];
        };
    in
    {
      nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
      formatter = forEachPkgs (pkgs: pkgs.nixfmt-rfc-style);
      devShells."x86_64-linux".default = mkShell "x86_64-linux";

      nixosConfigurations = {
        magnus = mkNixos "louis" "magnus" "x86_64-linux";
        akatosh = mkNixos "louis" "akatosh" "x86_64-linux";
      };
    };
}
