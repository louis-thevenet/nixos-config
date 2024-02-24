{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."git/allowed_signers".text = ''
    louis.tvnt@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHm46BX+FYHorkhOMmoUaL/BEczeg8vxedK7tzXUw6bV louis.tvnt@gmail.com
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
