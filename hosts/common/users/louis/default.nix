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
        ];
        shell = pkgs.fish;
        home = "/home/louis";
        hashedPasswordFile = passwordFile;
      };
      root = {
        # so, this may look like a security issue. I'm publicly showing the hash of my password. However:
        # 1. this password is extremely robust (~2000 bits of entropy)
        # 2. it is not used anywhere else
        # 3. it cannot be used to login over ssh
        # considering the odds of someone stealing my computer AND knowing how to crack this, I feel safe enough to put it here
        hashedPassword = "$6$uMII8BwKXF4lckbR$Fh5j1RRX6A..TnSyEGxj1pTHoTFxoIdRoPt7hmepfmdM4cVuXQZcr7aazdV4vIZ7KZLO5Xu6kvlDBwTOVaS8R/";
      };
    };
  };

  security.pam.services.swaylock = { };

  sops.secrets.wakatime_cfg = {
    sopsFile = ../../secrets.yaml;
    path = "/home/louis/.wakatime.cfg";
    owner = "louis";
  };
}
