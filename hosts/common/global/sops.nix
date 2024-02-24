{
  inputs,
  config,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];
  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.keyFile = "${config.users.users.louis.home}/.config/sops/age/keys.txt";
    secrets."sys-passphrase" = {
      neededForUsers = true;
    };
  };
}
