{ config, pkgs, ... }: {


  environment.systemPackages = with pkgs; [
    tree
    vim
    git
    kitty
  ];
}
