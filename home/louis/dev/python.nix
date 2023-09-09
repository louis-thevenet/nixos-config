{pkgs, ...}: {home.packages = with pkgs; [(python310.withPackages (ps: with ps; [bleak pyusb]))];}
