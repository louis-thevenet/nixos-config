{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Louis Thevenet";
    userEmail = "louis.tvnt@gmail.com";
  };
}
