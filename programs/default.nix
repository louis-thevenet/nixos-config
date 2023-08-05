{ config, pkgs, ... }: {

  imports = [
    ./system-programs.nix
    ./user-programs.nix
    ./home-manager.nix
  ];
  nixpkgs.config.allowUnfree = true;
}
