{pkgs, ...}: {
  imports = [
    ./global
    ./features
  ];

  home-config = {
    cli.commonTools.enable = true;
  };
}
