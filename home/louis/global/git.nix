{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."git/allowed_signers".text = ''
    louis.tvnt@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILaZo9ouDAWxdQnmqU3fi5OeaggjB0+gBEizITVviimc louis.tvnt@gmail.com
    louis.tvnt@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHzcuekFCsXm/zYTn78Xb3+g22OqFib+YaMRFsvRkBYi louis.tvnt@gmail.com
  '';
  services.ssh-agent = {
    enable = true;
  };
  programs.git = {
    enable = true;
    userName = "Louis Thevenet";
    userEmail = "louis.tvnt@gmail.com";

    extraConfig = {
      credential.helper = "store";
      commit.gpgsign = true;
      gpg = {
        format = "ssh";
      };
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";
      user.signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };
  };
}
