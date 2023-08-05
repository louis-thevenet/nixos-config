{ config, pkgs, ... }: {



  home-manager.users.louis.programs.zsh = {
    enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild --flake .#louis switch";
    };
    enableAutosuggestions = true;
    enableCompletion = true;

    plugins = [
      {
        name = "zsh-command-time";
        src = pkgs.fetchFromGitHub
          {
            owner = "popstas";
            repo = "zsh-command-time";
            rev = "803d26eef526bff1494d1a584e46a6e08d25d918";
            sha256 = "ndHVFcz+XmUW0zwFq7pBXygdRKyPLjDZNmTelhd5bv8=";
          };
        file = "command-time.plugin.zsh";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "history" "vscode" ];
      theme = "robbyrussell";
    };
  };
}


