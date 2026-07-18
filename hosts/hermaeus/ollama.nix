{ ... }:
let
  host = "192.168.1.183";
  port = 11434;
in
{
  networking.firewall.allowedTCPPorts = [ port ];

  environment.variables.OLLAMA_HOST = host; # so i can run stuff like `ollama pull`

  services.ollama = {
    enable = true;
    # package = pkgs.ollama-rocm;
    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "10m";
      OLLAMA_CONTEXT_LENGTH = "200000";
    };
    inherit host port;
  };
}
