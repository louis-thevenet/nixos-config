{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./vscode.nix
    ./oh-my-zsh.nix
    ./gnome.nix
    ./firefox.nix
    ./direnv.nix
  ];

  nixpkgs = {
    overlays = [ ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "louis";
    homeDirectory = "/home/louis";
    packages = with pkgs; [
      nil
      nixpkgs-fmt
      neofetch
      whatsapp-for-linux
      dotnet-sdk_7
      libgccjit
      spotify
      discord
      flameshot
      python311Packages.nix-prefetch-github
    ];
  };
  programs.home-manager.enable = true;
  programs.git.enable = true;


  home.stateVersion = "23.05";
}
