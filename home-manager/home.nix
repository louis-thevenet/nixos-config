{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./vscode.nix
    ./oh-my-zsh.nix
    ./gnome.nix
    ./firefox.nix
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
      #blueman
      nil
      nixpkgs-fmt
      neofetch
      #dotnet-sdk_8
      whatsapp-for-linux
      dotnet-sdk_7
      libgccjit
      spotify
      discord
      flameshot
      python311Packages.nix-prefetch-github
      libnotify
      direnv
    ];
  };
  programs.home-manager.enable = true;
  programs.git.enable = true;


  home.stateVersion = "23.05";
}
