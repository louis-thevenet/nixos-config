{ config, pkgs, ... }: {
  users.users.louis.packages = with pkgs; [
    blueman
    nil
    nixpkgs-fmt
    neofetch
    dotnet-sdk_8
    libgccjit
    spotify
    discord
    firefox
    flameshot
    python311Packages.nix-prefetch-github
  ];
}
