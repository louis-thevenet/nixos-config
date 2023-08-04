{
  description = "flake for louis with Home Manager enabled";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , home-manager
    , ...
    }:
    {

      nixosConfigurations = {
        louis = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.louis = { pkgs, ... }: {
                home.username = "louis";
                home.homeDirectory = "/home/louis";
                programs.home-manager.enable = true;
                home.packages = with pkgs; [
                  hello
                  blueman
                  spotify
                  kitty
                  discord
                  vim
                  firefox
                  flameshot
                  git
                ];
                home.stateVersion = "23.05";
              };
            }
          ];
        };
      };
    };
}
