{pkgs, ...}: {
  imports = [
    ./C.nix
    ./nix.nix
    ./python.nix
    ./jetbrains.nix
    ./typst.nix
    ./rust.nix
  ];
}
