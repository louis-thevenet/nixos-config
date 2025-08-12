switch HOST:
    sudo nixos-rebuild switch  --flake .#{{HOST}} --impure -v

remote-switch-dagon ADDR PORT:
    NIX_SSHOPTS="-p {{PORT}}" nixos-rebuild switch --flake .#dagon --target-host louis@{{ADDR}} --ask-sudo-password -v --impure
old-remote-switch-dagon ADDR PORT:
    NIX_SSHOPTS="-p {{PORT}}" nixos-rebuild switch --flake .#dagon --target-host louis@{{ADDR}}  -v --impure
