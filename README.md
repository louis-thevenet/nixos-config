# NixOS Hyprland flake setup

![image](https://github.com/user-attachments/assets/8cc89a79-9bfd-4882-bbca-07f925fd1338)

![image](https://github.com/user-attachments/assets/eeccd1de-dc22-4cf0-8a91-444e31e507fb)

## Features

- Hyprland (Hypridle, Hyprlock, Hyprpaper, Mako, Albert, Swaync, Waybar)
- Niri (with mostly the same wayland DE)
- Nix Flakes
- Theme handled by [Stylix](https://github.com/danth/stylix)
- Automatic light and dark themes
- Multiple hosts
- Home config as a Nix Module
- Home Impermanence (on Akatosh)
- Secrets Management

## NixOS Config

```rust
hosts
├── akatosh
│  ├── default.nix
│  ├── hardware-configuration.nix
│  └── sops.nix
├── common
│  ├── global
│  ├── optional
│  ├── secrets.yaml
│  └── users
└── magnus
   ├── default.nix
   ├── hardware-configuration.nix
   └── sops.nix
```

- `magnus` : Main System
- `akatosh` : Laptop (disk managed with [disko](https://github.com/nix-community/disko) with [impermanence](https://nixos.wiki/wiki/Impermanence) for NixOS)

The setup is rather classic, most of the system configuration is shared between hosts.

## HomeManager Config

```
.
└── louis
    ├── akatosh.nix
    ├── features
    │   ├── cli
    │   ├── default.nix
    │   ├── desktop
    │   ├── dev
    │   ├── gaming
    │   ├── gui
    │   ├── impermanence.nix
    │   ├── misc
    │   └── virtualization
    ├── global
    │   ├── default.nix
    │   ├── home-manager.nix
    │   ├── options
    │   └── tools
    └── magnus.nix
```

There are some tools enabled by default (`home/louis/global/tools.nix`, `helix`) but most features are optional.

Features are enabled using options defined in (`home/louis/global/options`). See `magnus.nix`:

```nix
home-config = {
  cli.commonTools.enable = true;   # eza, bat, wget, ...
   gui = {
      kitty.enable = true;         # terminal
      firefox = {
        enable = true;
        searxngInstance = { # privacy-focused search engine
          local = true; # self-hosted
          url = "http://127.0.0.1";
          port = 30070;
        };
        homepageUrl = "localhost:30069"; # glance homepage
      };
      glance = {
        enable = true;
        host = "localhost";
        port = 30069;
      };
      social.enable = true; # discord, beeper, ...
      utils.enable = true;# spotify, file manager, calibre, ...
      ai.lmstudio.enable = true;
    };
    dev = {
      vscode.enable = true;
      devTools.enable = true; # tokei, tmux, ...
    };
    desktop.wayland = {
      enable = true; # contains most of my wayland "DE" (waybar, albert, swaync, ...)
      # hyprland = {
      #   enable = true;
      #   nvidia = true;
      # };
      niri.enable = true;
    };
  virtualization.enable = true;   # qemu, ...
  # other options exists (gaming, ...)
};
```

## Theming

Style is handled by [Stylix](https://github.com/danth/stylix):

Theme and wallpaper auto switch from light to dark on sunset using darkman and nix specialisations.

# What you would change to use this config

## Delete what you wouldn't use

Here are some (random) examples:

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

- You should already have changed `magnus`'s config to be yours
- You should probably follow this algorithm:
- Comment out all features in `./home/USERNAME/HOSTNAME.nix`
- For each feature, see what it enables, remove what you don't want, then enable it or not
- You should be good to rebuild : `sudo nixos-rebuild --flake .#HOSTNAME boot` then `reboot now`.
