{
  pkgs,
  config,
  ...
}:
let
  passwordFile = config.sops.secrets.sys-passphrase.path;
in
{
  users = {
    mutableUsers = false;
    users = {
      louis = {
        isNormalUser = true;
        description = "louis thevenet";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
        ];
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0w5CDimW+k9ic7fOJ3aNjFA9Bhe1LT4Bb0bczrheKr louis.tvnt@gmail.com"
        ];
        home = "/home/louis";
        hashedPasswordFile = passwordFile;
      };
      root = {
        # so, this may look like a security issue. I'm publicly showing the hash of my password. However:
        # 1. this password is extremely robust (~2000 bits of entropy)
        # 2. it is not used anywhere else
        # 3. it cannot be used to login over ssh
        # considering the odds of someone stealing my computer AND knowing how to crack this, I feel safe enough to put it here
        hashedPassword = "$y$j9T$mK2B12LyU3mVF7gdvY2F70$qCV.AJvR34tA6S/T0SgqbNyssh/sezQF43fv3RnEKFA";
      };
    };
  };
  sops.secrets.wakatime_cfg = {
    sopsFile = ../../secrets.yaml;
    path = "/home/louis/.wakatime.cfg";
    owner = "louis";
  };
}
