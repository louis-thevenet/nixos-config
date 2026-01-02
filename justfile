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
    # Copy NixOS config files (exclude git ignored files like ./result)
    rsync --filter=':- .gitignore' --info=ALL -e 'ssh -p {{PORT}}' --recursive $NH_FLAKE {{ADDR}}:tmp_nixos_config
    # Deploy HM config
    ssh {{ADDR}} -p {{PORT}} "cd ~/tmp_nixos_config/nixos-config && nix run nixpkgs#home-manager -- build --flake .#louis@dagon"
    ssh {{ADDR}} -p {{PORT}} "rm -rf tmp_nixos_config"
