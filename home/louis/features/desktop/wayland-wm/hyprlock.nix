{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
  inherit (config.lib.stylix) colors;
in
{
  home.packages = mkIf cfg.hyprland.enable (
    with pkgs;
    [
      hyprlock
    ]
  );
  home.file.".config/hypr/hyprlock.conf".text = ''

    $text_color = 0xff${colors.base05}
    $entry_background_color = 0xff${colors.base00}
    $entry_border_color = 0xff${colors.base03}
    $entry_color = 0xff${colors.base05}
    $font_family = Gabarito
    $font_family_clock = Gabarito
    $font_material_symbols = Material Symbols Rounded

    input-field {
        monitor =
        size = 250, 50
        outline_thickness = 2
        dots_size = 0.1
        dots_spacing = 0.3
        outer_color = $entry_border_color
        inner_color = $entry_background_color
        font_color = $entry_color
        # fade_on_empty = true

        position = 0, 20
        halign = center
        valign = center
    }

    background {
    # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
    path = screenshot
    blur_passes = 3 # 0 disables blurring
    blur_size = 7
    noise = 0.0117
    contrast = 0.8916
    brightness = 1 # 0.8172
    vibrancy = 0.1696
    vibrancy_darkness = 0.0
    }


    label { # Clock
        monitor =
        text = $TIME
        color = $text_color
        font_size = 65
        font_family = $font_family_clock

        position = 0, 300
        halign = center
        valign = center
    }
    label {
        monitor =
        text = 🔒 $USER
        color = $text_color
        font_size = 20
        font_family = $font_family

        position = 0, 240
        halign = center
        valign = center
    }
  '';
}
