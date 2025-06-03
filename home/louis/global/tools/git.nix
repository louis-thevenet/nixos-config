{
  config,
  pkgs,
  ...
}:
{
  # magnus
  # hircine
  # akatosh
  xdg.configFile."git/allowed_signers".text = ''
    louis.tvnt@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0w5CDimW+k9ic7fOJ3aNjFA9Bhe1LT4Bb0bczrheKr louis.tvnt@gmail.com
  '';
  services.ssh-agent = {
    enable = true;
  };
  programs.git = {
    enable = true;
    userName = "Louis Thevenet";
    userEmail = "louis.tvnt@gmail.com";

    extraConfig = {
      merge.mergiraf = {
        name = "mergiraf";
        driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P";

      };
      core.attributesfile = toString (
        pkgs.writeTextFile {
          name = ".gitattributes";
          text = ''
            *.java merge=mergiraf
            *.rs merge=mergiraf
            *.go merge=mergiraf
            *.js merge=mergiraf
            *.jsx merge=mergiraf
            *.json merge=mergiraf
            *.yml merge=mergiraf
            *.yaml merge=mergiraf
            *.toml merge=mergiraf
            *.html merge=mergiraf
            *.htm merge=mergiraf
            *.xhtml merge=mergiraf
            *.xml merge=mergiraf
            *.c merge=mergiraf
            *.cc merge=mergiraf
            *.h merge=mergiraf
            *.cpp merge=mergiraf
            *.hpp merge=mergiraf
            *.cs merge=mergiraf
            *.dart merge=mergiraf
            *.scala merge=mergiraf
            *.sbt merge=mergiraf
            *.ts merge=mergiraf
            *.py merge=mergiraf
          '';
        }
      );
      credential.helper = "store";
      commit.gpgsign = true;
      gpg = {
        format = "ssh";
      };
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";
      user.signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };
    difftastic = {
      enable = true;
    };
  };
  home.packages = [ pkgs.mergiraf ];
}
