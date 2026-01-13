hostname := shell('hostname')
switch-nixos:
    sudo nixos-rebuild switch --flake .#{{hostname}} --impure -v
switch-hm:
    home-manager switch --flake .#louis@{{hostname}}

remote-switch-nixos HOST ADDR PORT:
    # Remote build and deploy NixOS config
    NIX_SSHOPTS="-p {{PORT}}" nixos-rebuild switch --flake .#{{HOST}} --target-host louis@{{ADDR}} --ask-sudo-password -v --impure
remote-switch-hm HOST ADDR PORT:
    home-manager build --flake .#louis@{{HOST}}
    NIX_SSHOPTS="-p {{PORT}}" nix copy --to ssh://{{ADDR}} ./result
    ssh {{ADDR}} -p {{PORT}} "$(readlink -f ./result)/activate"
