{
  # config,
  ...
}:
{
  imports = [
    # ./hardware-configuration.nix
    ./sops.nix
    ../common/global
    ../common/users/louis
  ];
  networking.hostName = "dagon";

}
