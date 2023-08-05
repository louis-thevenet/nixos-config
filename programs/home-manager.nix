{ config, pkgs, ... }: {
  imports = [
    ./vscode.nix
    ./oh-my-zsh.nix
  ];
  home-manager = {
    useGlobalPkgs = true;

    users.louis = {
      home = {
        stateVersion = "23.05";
        username = "louis";
      };
      home.packages = with pkgs;
        [

        ];
    };
  };
}

