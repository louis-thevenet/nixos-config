{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    shellAliases = {
      sys-update-l = "sudo nixos-rebuild --flake .#hircine switch";
      sys-update-d = "sudo nixos-rebuild --flake .#magnus switch";
      home-update-d = "home-manager --flake .#louis@magnus switch";
      home-update-l = "home-manager --flake .#louis@hircine switch";

      vim = "hx";

      ls = "eza --long --header --binary --no-permissions --no-user";
      lss = "ls --total-size";
      lsg = "ls --git";
      cat = "bat --theme=\"Solarized (light)\"";
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    plugins = [
      {
        name = "zsh-command-time";
        src =
          pkgs.fetchFromGitHub
          {
            owner = "popstas";
            repo = "zsh-command-time";
            rev = "803d26eef526bff1494d1a584e46a6e08d25d918";
            sha256 = "ndHVFcz+XmUW0zwFq7pBXygdRKyPLjDZNmTelhd5bv8=";
          };
        file = "command-time.plugin.zsh";
      }

      #   {
      #     name = "zsh-airpods-battery";
      #     src =
      #       pkgs.fetchFromGitHub
      #       {
      #         owner = "louis-thevenet";
      #         repo = "zsh-airpods-battery";
      #         rev = "46edc4b782d9b5a2a29f30a64aa22e2da1305f5e";
      #         sha256 = "TORbJOSFGk2/9Fj798E+eGnkucfr/btuellFhkzpf/8=";
      #       };
      #     file = "airpods-battery.plugin.zsh";
      #   }

      #   {
      #     name = "zsh-autocomplete";
      #     src =
      #       pkgs.fetchFromGitHub
      #       {
      #         owner = "marlonrichert";
      #         repo = "zsh-autocomplete";
      #         rev = "23.07.13";
      #         sha256 = "sha256-0NW0TI//qFpUA2Hdx6NaYdQIIUpRSd0Y4NhwBbdssCs=";
      #       };
      #     file = "zsh-autocomplete.plugin.zsh";
      #   }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "web-search" "history" "copypath" "copyfile" "vscode" "rust" "direnv"];
      theme = "candy";
    };
  };
}
