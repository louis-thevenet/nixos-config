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
      # GUI
      whatsapp-for-linux
      discord
      spotify
      anytype
      bitwarden

      # CLI
      neofetch
      exa
      bat
      trash-cli
      du-dust
      git-open

      noti
      tokei

      # nix
      nil
      nixpkgs-fmt
      python311Packages.nix-prefetch-github

      # C
      cmake
      gcc
      clang-tools
      valgrind
      gdb
      hyperfine

      # python
      (python310.withPackages (ps: with ps; [ bleak pyusb ]))
    ];
  };
  programs.home-manager.enable = true;
  programs.git.enable = true;


  home.stateVersion = "23.05";
}
