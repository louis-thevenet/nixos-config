{pkgs, ...}: {
  imports = [
    ./C.nix
    ./nix.nix
    ./python.nix
  ];
}
