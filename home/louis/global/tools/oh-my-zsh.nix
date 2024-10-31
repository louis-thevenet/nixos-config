{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases =
      let
        eza = lib.getExe pkgs.eza;
        helix = lib.getExe pkgs.helix;
        dysk = lib.getExe pkgs.dysk;
        bat = lib.getExe pkgs.bat;
        broot = lib.getExe pkgs.broot;
        dust = lib.getExe pkgs.dust;
      in
      {
        rebuild-sys = "nh os switch /home/louis/src/nixos-config";
        update-sys = "nh os switch /home/louis/src/nixos-config --update";

        vim = helix;

        ls = "${eza} --long --header --binary --no-permissions --no-user --icons=auto";
        lss = "${eza} --total-size";
        lst = "${eza} --tree";
        lsg = "${eza} --git";

        cat = "${bat} --theme=\"Solarized (light)\"";

        tree = broot;
        du = dust;

        df = dysk;
      };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    plugins = [
      {
        name = "zsh-command-time";
        src = pkgs.fetchFromGitHub {
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
      plugins = [
        "git"
        "web-search"
        "history"
        "copypath"
        "copyfile"
        "vscode"
        "rust"
        "direnv"
        "fzf"
      ];
      theme = "candy";
    };
  };
}
