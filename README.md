# NixOS Hyprland flake setup
![image](https://github.com/user-attachments/assets/babe7c25-b7e1-43b6-bba7-abe00aa80fbd)
![image](https://github.com/user-attachments/assets/1dc4faea-9f66-4a4a-82c6-782b56627114)

*Unfocused windows are grayed out*
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
│  └── hardware-configuration.nix
└── magnus
   ├── default.nix
   └── hardware-configuration.nix
```
- `magnus` : Main System
- `hircine` : Laptop

The setup is rather classic, most of the system configuration is shared between hosts.

## HomeManager Config

```
/home/louis
├── features
│  ├── cli
│  ├── default.nix
│  ├── desktop
│  ├── dev
│  ├── gaming
│  ├── gui
│  ├── misc
│  └── virtualization
├── global
│  ├── default.nix
│  ├── home-manager.nix
│  ├── options
│  ├── stylix.nix
│  └── tools
├── hircine.nix
└── magnus.nix
```

There are some tools enabled by default (`home/louis/global/tools.nix`) but most features are optional.

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

Style is handled by `Stylix`:

(Theme auto switches from light to dark on sunset using darkman and nix specialisations)

```nix
stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://images.pexels.com/photos/167698/pexels-photo-167698.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1";
      sha256 = "sha256-/Pw6zZ41isjbUwsaFOt2YWhE7oD8D6kNdLsaGtUdBrI=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
    cursor = {
      package = pkgs.numix-cursor-theme;
      name = "Numix-Cursor-Light";
      size = 22;
    };
    fonts = {
      monospace = {
        name = "FiraCode Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
  };

  specialisation = {
    light.configuration = {
      stylix.base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
    };

    dark.configuration = {
      stylix.base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
    };
  };
```

You also need to configure monitors (only for Hyprland):
```nix
monitors = [
    {
      name = "eDP-1";  # laptop
      width = 1920;
      height = 1080;
      x = 0;
      workspace = "1";
      primary = true;
    }
  ];
```

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
- Enable experimental features in your initial configuration if it's not already done
- Clone the repo
- Replace all occurences of `louis` by your username
- Replace all occurences of `magnus` by your hostname
- Either remove secrets management through `sops` or replace them with your own secrets. A hashed password could be considered as being enough so don't bother with secrets if you don't have any. (that's in `./hosts/common/users/USERNAME/default.nix`)
- Replace `hardware-config.nix` with your own file produced by `nixos-generate-config`.

### Home Manager
- you should already have changed `magnus`'s config to be yours
- You should probably follow this algorithm:
- Comment out all features in `./home/USERNAME/HOSTNAME.nix`
- For each feature, see what it enables, remove what you don't want, then enable it

- You should be good to rebuild : `sudo nixos-rebuild --flake .#HOSTNAME boot` then `reboot now`.
