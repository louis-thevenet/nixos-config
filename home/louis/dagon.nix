{ ... }:
{
  imports = [
    ./global
    ./features
  ];
  home-config = {
    cli.commonTools.enable = true;
    dev.devTools.enable = true;
  };
}
