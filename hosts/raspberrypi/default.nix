{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./nextcloud.nix
    inputs.sops-nix.nixosModules.sops
  ];
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/louis/.config/sops/age/keys.txt";
    secrets."nextcloud-admin-password" = {
    };
  };
}
