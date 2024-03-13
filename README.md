# My *always changing* NixOS + Hyprland config
![2024-03-13T19:55:43,570563663+01:00](https://github.com/louis-thevenet/nixos-config/assets/55986107/389b6451-79cc-4e33-b10e-a8380edd36dc)
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
home/louis
├── features
│  ├── cli
│  ├── default.nix
│  ├── desktop
│  ├── dev
│  ├── gaming
│  ├── gui
│  └── virtualization
├── global
│  ├── default.nix
│  ├── home-manager.nix
│  ├── options
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

You also need to configure monitors (only for Hyprland) and fonts:
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

  fontProfiles = {
    enable = true;
    monospace = {
      family = "FiraCode Nerd Font";
      package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };
```
