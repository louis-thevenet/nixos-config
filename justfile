switch HOST:
    sudo nixos-rebuild switch  --flake .#{{HOST}} --impure -v

remote-switch-dagon ADDR PORT:
    NIX_SSHOPTS="-p {{PORT}}" nixos-rebuild switch --flake .#dagon --target-host louis@{{ADDR}} --use-remote-sudo -v --impure
