{
  pkgs,
  lib,
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
        basename = lib.getExe' pkgs.coreutils "basename";
        pwd = lib.getExe' pkgs.coreutils "pwd";
      in
      {
        tmn.body = "${tmux} new-session -A -s $(${basename} $(${pwd}))";
        tma.body = "${tmux} attach -t $(${tmux} list-sessions | ${tv} --preview-command 'tmux list-windows -t {0}' | ${cut} -d':' -f1)";
        tmw.body = ''
          set session (${tmux} list-sessions | ${tv} --preview-command 'tmux list-windows -t {0}' | ${cut} -d':' -f1)
          ${tmux} attach -t $session:(${tmux} list-windows -t $session | ${tv} | ${cut} -d':' -f1)
        '';
        rerun = ''
          argparse 'd/dry-run' -- $argv
          if test (count $argv) -ne 1
              echo "Usage: rerun [--dry-run|-d] N"
              return 1
          end

          set -l n $argv[1]
          set -l count 0
          set -l commands

          for cmd in (history | grep -v '^rerun') # skip rerun calls
              if test $count -ge $n
                  break
              end
              set commands $cmd $commands  # prepend to preserve order
              set count (math $count + 1)
          end

          if test $count -lt $n
              echo "Only found $count non-rerun commands in history"
          end

          for cmd in $commands
              echo "> $cmd"
              if not set -q _flag_dry_run
                  eval $cmd
              end
          end
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
        helix = lib.getExe pkgs.helix;
        dysk = lib.getExe pkgs.dysk;
        bat = lib.getExe pkgs.bat;
        broot = lib.getExe pkgs.broot;
        dust = lib.getExe pkgs.dust;
        git = lib.getExe pkgs.git;
      in
      {
        which = "readlink -f (type -p $argv)";
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
