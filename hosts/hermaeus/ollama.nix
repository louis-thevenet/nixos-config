{ pkgs, ... }: {
  services.ollama = {
    enable = true;
    # package = pkgs.ollama-rocm;
    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "10m";
      OLLAMA_CONTEXT_LENGTH = "200000";
    };
  };
  environment.systemPackages = [ pkgs.llama-cpp ];
}
