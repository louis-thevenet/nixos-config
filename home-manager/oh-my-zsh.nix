{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    shellAliases = {
      update-d = "sudo nixos-rebuild --flake .#louisdesktop switch";
      update-l = "sudo nixos-rebuild --flake .#louislaptop switch";

      exa-l = "exa -l --header -b";


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

      # {
      #   name = "zsh-notify";
      #   src = pkgs.fetchFromGitHub
      #     {
      #       owner = "marzocchi";
      #       repo = "zsh-notify";
      #       rev = "9c1dac81a48ec85d742ebf236172b4d92aab2f3f";
      #       hash = "sha256-ovmnl+V1B7J/yav0ep4qVqlZOD3Ex8sfrkC92dXPLFI=";
      #     };
      #   file = "notify.plugin.zsh";
      # }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "history" "vscode" ];
      theme = "robbyrussell";
    };
  };
}


