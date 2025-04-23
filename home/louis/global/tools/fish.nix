{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.fish = {
    enable = true;
    functions =
      let
        tmux = lib.getExe pkgs.tmux;
        tv = lib.getExe pkgs.television;
        cut = lib.getExe' pkgs.coreutils "cut";
      in
      {
        tma.body = "${tmux} attach -t $(${tmux} list-sessions | ${tv} --preview 'tmux list-windows -t {0}' | ${cut} -d':' -f1)";
        tmw.body = ''
          session=$(${tmux} list-sessions | ${tv} --preview 'tmux list-windows -t {0}' | ${cut} -d':' -f1);
          ${tmux} attach -t ''${session}:$(${tmux} list-windows -t ''${session} | ${tv} | ${cut} -d':' -f1)
        '';
      };

    shellAbbrs = {
      # safety measures
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";

      mkdir = "mkdir -p";
    };

    shellAliases =

      let
        eza = lib.getExe pkgs.eza;
        helix = lib.getExe inputs.helix.packages.${pkgs.system}.default;
        dysk = lib.getExe pkgs.dysk;
        bat = lib.getExe pkgs.bat;
        broot = lib.getExe pkgs.broot;
        dust = lib.getExe pkgs.dust;
        nh = lib.getExe inputs.nh.packages.${pkgs.system}.default;
        git = lib.getExe pkgs.git;
      in

      {
        which = "readlink -f (type -p $argv)";
        rebuild-sys = "${nh} os switch /home/louis/src/nixos-config";
        update-sys = "${nh} os switch /home/louis/src/nixos-config --update";

        vim = helix;

        ls = "${eza} --long --header --binary --no-permissions --no-user --icons=auto";
        lss = "ls --total-size";
        lst = "ls --tree";
        lsg = "ls --git";

        cat = bat;
        tree = broot;
        du = dust;
        df = dysk;
        g = git;

        hxtv = "hx $(tv)";

      };

    interactiveShellInit = ''
      # Open command buffer in vim when alt+e is pressed
      bind \ee edit_command_buffer
    '';
  };
}
