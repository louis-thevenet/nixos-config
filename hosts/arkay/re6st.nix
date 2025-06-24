{
  inputs,
  pkgs,
  config,
  ...
}:
{
  environment.defaultPackages = [
    inputs.re6stnet.packages.${pkgs.system}.re6stnet
  ];
  re6stnet = {
    enable = true;
    security = {
      certificateAuthorityPath = "${config.users.users.louis.home}/ca.crt";
      certificatePath = "${config.users.users.louis.home}/cert.crt";
      certificateKeyPath = "${config.users.users.louis.home}/cert.key";
    };
    interfaces = [ "wlp0s20f3" ];
    re6stnetExtraOptions = [
      # increase re6stnet verbosity:
      "verbose 3"
      # enable OpenVPN logging:
      "ovpnlog"
      # increase OpenVPN verbosity:
      "O--verb"
      "O3"
    ];
  };
}
