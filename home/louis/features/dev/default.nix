{ pkgs, ... }:
{
  imports = [
    ./devtools.nix
    ./jetbrains.nix
    ./vscode.nix
  ];
}
