switch HOST:
    sudo nixos-rebuild switch --flake .#{{HOST}} --impure -v
    home-manager switch --flake .#louis@akatosh

remote-switch-dagon ADDR PORT:
    # Remote build and deploy NixOS config
    NIX_SSHOPTS="-p {{PORT}}" nixos-rebuild switch --flake .#dagon --target-host louis@{{ADDR}} --ask-sudo-password -v --impure
    # Build HM config locally
    home-manager build --flake .#louis@dagon
    # Copy HM closure
    NIX_SSHOPTS="-p {{PORT}}" nix copy --to ssh://{{ADDR}} ./result
    ssh {{ADDR}} -p {{PORT}} "$(readlink -f ./result)/activate"
