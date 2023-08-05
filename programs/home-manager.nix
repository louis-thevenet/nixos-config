{ config, pkgs, ... }: {
  imports = [
    ./vscode.nix
  ];
  home-manager = {
    useGlobalPkgs = true;
    home = {
      stateVersion = "23.05";
      username = "louis";
    };
    users.louis = {
      home.packages = with pkgs;
        [
        ];
    };
  };
}

