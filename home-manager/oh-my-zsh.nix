{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    shellAliases = {
      update-desktop = "sudo nixos-rebuild --flake .#louisdesktop switch";
      update-laptop = "sudo nixos-rebuild --flake .#louislaptop switch";
      home-update = "home-manager --flake .#louis@nixos switch";

      lx = "exa -l --header -b";


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

      {
        name = "zsh-airpods-battery";
        src = pkgs.fetchFromGitHub
          {
            owner = "A-delta";
            repo = "zsh-airpods-battery";
            rev = "351458cbe2f85302b7917b71083f299c5de123a9";
            sha256 = "GCosmN1HE8f/D6/Vh4Ritq8NcQ4Uetf5qRxzyO3l8W0=";
          };
        file = "airpods-battery.plugin.zsh";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "history" "vscode" ];
      theme = "robbyrussell";
    };
  };
}


