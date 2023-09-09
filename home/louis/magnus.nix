{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./features/vscode.nix
    ./features/neovim.nix
    ./features/oh-my-zsh.nix
    ./features/gnome.nix
    ./features/firefox.nix
    ./features/direnv.nix
    ./features/git.nix
    ./features/kitty.nix
  ];

  nixpkgs = {
    overlays = [];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "louis";
    homeDirectory = "/home/louis";
    packages = with pkgs; [
      # GUI
      whatsapp-for-linux
      spotify
      anytype
      bitwarden
      tor-browser-bundle-bin
      discord
      libsForQt5.okular
      betterdiscordctl
      # CLI
      neofetch
      exa
      bat
      trash-cli
      du-dust
      git-open
      screen

      noti
      tokei

      # nix
      nil
      alejandra
      python311Packages.nix-prefetch-github

      # C
      cmake
      gnat13
      clang-tools
      valgrind
      gdb
      hyperfine

      # python
      (python310.withPackages (ps: with ps; [bleak pyusb]))
    ];
  };
  programs.home-manager.enable = true;
  programs.git.enable = true;

  home.stateVersion = "23.05";
}
