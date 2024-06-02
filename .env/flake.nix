{
  description = "A flake-based Nix development environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {system = system;};
  in {
    devShells."x86_64-linux".default = pkgs.mkShell {
      packages = with pkgs; [
        nil
        nixpkgs-fmt
        python311Packages.nix-prefetch-github
        home-manager
        nixos-generators
        nix-du
        graphviz
        sops
        age
      ];
    };

    # Add your auto-formatters here.
    # cf. https://numtide.github.io/treefmt/
    treefmt.config = {
      projectRootFile = "flake.nix";
      programs = {
        nixpkgs-fmt.enable = true;
      };
    };
  };
}
