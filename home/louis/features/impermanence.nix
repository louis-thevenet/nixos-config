{ inputs, ... }:
{
  imports = [
    (inputs.impermanence + "/home-manager.nix")
  ];

  home.persistence."/persist/home/louis" = {
    directories = [
      "src"
      "Downloads"
      "Documents"
      ".ssh"
      ".zsh"
      ".config"
      ".local/share/keyrings"
      ".local/share/direnv"
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];
    files =
      [
      ];
    allowOther = true;
  };
}
