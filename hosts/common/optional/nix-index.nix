{ inputs, ... }:
{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];
  programs = {
    nix-index-database.comma.enable = true;
    nix-index.enable = true;
  };
}
