{
  inputs,
  config,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];
  sops = {
    defaultSopsFile = ../common/secrets.yaml;
    age.keyFile = "/persist/var/lib/sops-nix/key.txt";

    secrets."sys-passphrase" = {
      neededForUsers = true;
    };
  };
}
