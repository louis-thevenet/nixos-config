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
      neofetch
      whatsapp-for-linux
      spotify
      discord
      exa
      bat
      du-dust
      git-open
      jrnl
      navi
      noti
      tokei
      obsidian

      nil # nix lsp
    ];
  };
  programs.home-manager.enable = true;
  programs.git.enable = true;


  home.stateVersion = "23.05";
}
