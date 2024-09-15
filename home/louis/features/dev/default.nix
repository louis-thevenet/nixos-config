{pkgs, ...}: {
  imports = [
    ./devtools.nix
    ./jetbrains.nix
    ./vscode.nix
    ./vale.nix
    ./eclipse.nix
  ];
}
