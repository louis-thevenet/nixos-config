{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./vscode.nix
    ./oh-my-zsh.nix
    ./gnome.nix
    ./firefox.nix
    ./direnv.nix
    ./git.nix
    ./kitty.nix
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
      whatsapp-for-linux
      discord
      spotify

      neofetch
      exa
      bat
      trash-cli
      du-dust
      git-open

      noti
      tokei
      anytype

      cmake

      # nix
      nil
      nixpkgs-fmt
      python311Packages.nix-prefetch-github

      # C
      gcc
      clang-tools
      valgrind
      gdb
      hyperfine
    ];
  };
  programs.home-manager.enable = true;
  programs.git.enable = true;


  home.stateVersion = "23.05";
}
