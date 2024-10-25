{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
}
