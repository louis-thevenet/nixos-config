# NixOS Hyprland flake setup

![image](https://github.com/user-attachments/assets/babe7c25-b7e1-43b6-bba7-abe00aa80fbd)
![image](https://github.com/user-attachments/assets/1dc4faea-9f66-4a4a-82c6-782b56627114)

## NixOS Config
```
hosts
├── common
│  ├── global
│  ├── optional
│  ├── secrets.yaml
│  └── users
├── hircine
│  ├── default.nix
│  ├── hardware-configuration.nix
│  └── sops.nix
└── magnus
   ├── default.nix
   ├── hardware-configuration.nix
   └── sops.nix
```
- `magnus` : Main System
- `hircine` : Laptop (disk managed with [disko](https://github.com/nix-community/disko) with [impermanence](https://nixos.wiki/wiki/Impermanence) for NixOS)

The setup is rather classic, most of the system configuration is shared between hosts.

## HomeManager Config

```
home
└── louis
   ├── features
   │  ├── cli
   │  ├── default.nix
   │  ├── desktop
   │  ├── dev
   │  ├── gaming
   │  ├── gui
   │  ├── impermanence.nix
   │  ├── misc
   │  └── virtualization
   ├── global
   │  ├── default.nix
   │  ├── home-manager.nix
   │  ├── options
   │  └── tools
   ├── hircine.nix
   └── magnus.nix
```

There are some tools enabled by default (`home/louis/global/tools.nix`, `helix`) but most features are optional.

Features are enabled using options defined in (`home/louis/global/options`). See `magnus.nix`:
```nix
home-config = {
  cli.commonTools.enable = true;   # eza, bat, wget, ...
  gui = {
    kitty.enable = true;
    schizofox.enable = true;       # "super ultra privacy friendly firefox config"
    social.enable = true;
    utils.enable = true;           # spotify, file manager, calibre, ...
  };
  dev = {
    vscode.enable = true;
    devTools.enable = true;       # tokei, tmux, ...
  };
  desktop.hyprland.enable = true; # Gnome is also an option
  virtualization.enable = true;   # qemu, ...
  # other options exists (gaming, ...)
};
```

## Theming
Style is handled by [Stylix](https://github.com/danth/stylix):

Theme and wallpaper auto switch from light to dark on sunset using darkman and nix specialisations.

# What you would change to use this config
## Delete what you wouldn't use
Here are some random examples:
- Schizofox
- Nextcloud
- Helix/NixVim
- Some VSCode extensions
- LMStudio
- Git signing keys

## What you need to do
### NixOS
- Have experimental features (nix-commands and flakes) enabled in your initial configuration
- Clone the repo
- Replace all occurences of `louis` by your username
- Replace all occurences of `magnus` or `hircine` by your hostname (only hircine uses impermanence)
- Either remove secrets management through `sops` or replace them with your own secrets. A hashed password could be considered as being enough so don't bother with secrets if you don't have any. (that's in `./hosts/common/users/USERNAME/default.nix`)
- Replace `hardware-config.nix` with your own file produced by `nixos-generate-config`.

### Home Manager
- you should already have changed `magnus`'s config to be yours
- You should probably follow this algorithm:
- Comment out all features in `./home/USERNAME/HOSTNAME.nix`
- For each feature, see what it enables, remove what you don't want, then enable it or not
- You should be good to rebuild : `sudo nixos-rebuild --flake .#HOSTNAME boot` then `reboot now`.
