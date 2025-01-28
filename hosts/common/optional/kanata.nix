{ ... }:
{
  hardware.uinput.enable = true;
  # Set up udev rules for uinput
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  # Ensure the uinput group exists
  users.groups.uinput = { };

  # Add the Kanata service user to necessary groups
  systemd.services.kanata-internalKeyboard.serviceConfig = {
    SupplementaryGroups = [
      "input"
      "uinput"
    ];
  };

  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [
          # Replace the paths below with the appropriate device paths for your setup.
          # Use `ls /dev/input/by-path/` to find your keyboard devices.
          "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:10:1.0-event-kbd"
          "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:10:1.2-event-kbd"
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        ];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''


             ;; Timing variables for tap-hold effects.
             (defvar
               ;; The key must be pressed twice in 200ms to enable repetitions.
               tap_timeout 200
               ;; The key must be held 200ms to become a layer shift.
               hold_timeout 200
               ;; Slightly higher value for typing keys, to prevent unexpected hold effect.
               long_hold_timeout 300
             )

             (deflocalkeys-linux
             OEM_7 41
             a 16
             z 17
             q 30
             w 44
             m 39
             OEM_10 86

             1 2
             2 3
             3 4
             4 5
             5 6
             6 7
             7 8
             8 9
             9 10
             0 11

             OEM_6 26
             OEM_1 27
             OEM_4 12
             OEM_MINUS 13
             OEM_PLUS 53
             OEM_2 52
             OEM_PERIOD 51
             OEM_COMMA 50
             OEM_3 40
             )

             ;; source layout
             (defsrc
               1 2 3 4 5 6 7 8 9 0
            tab a z e r t  y u i o p
           caps q s d f g   h j k l m
                < w x c v b n OEM_COMMA OEM_PERIOD OEM_2 OEM_PLUS rsft
                  lalt                    spc                    ralt 
              )

             ;; base layout
             (deflayer base
              1 2 3 4 5 6 7 8 9 0
             @tab  a z e r t y u i o p
          esc q s d f g h j k l m
               < w x c v b n OEM_COMMA OEM_PERIOD OEM_2 OEM_PLUS rsft
               @alt                   @nav                   @sym
             )

             (defalias
               ;; Main mod-tap: Nav layer when held, Space when tapped.
               nav (tap-hold $tap_timeout $long_hold_timeout spc (layer-while-held navigation))

               ;; Space-cadet thumb keys: Alt/BackSpace, AltGr/Enter.
               ;; Acts as a modifier by default, or as BackSpace/Enter when tapped separately.
               alt (tap-hold-press $tap_timeout $hold_timeout bspc lalt)
               sym (tap-hold-press $tap_timeout $hold_timeout ret (layer-while-held symbols))
              tab (tap-hold-press $tap_timeout $hold_timeout tab (layer-while-held ergol))
             )

             ;; Symbol layer: Lafayette/Ergo‑L AltGr programmation layer for the masses!

             ;; ergol layout
             (deflayer ergol
              1 2 3 4 5 6 7 8 9 0
             tab q c o p w j m d @! y
            esc a s e n f l r t i u
               < z x @? v b @: h g @; k rsft
               _                    _ _
             )

             (deflayer symbols
               AG-1 AG-2 AG-3 AG-4 AG-5 AG-6 AG-7 AG-8 AG-9 AG-0
          tab @^   @<   @>   @$   @%        @@   @&   @*   @'   @`
          esc @{ @pl  @pr  @}   @=        @\   @+   @-   @/  @dq 
              @< @~   @[   @]   @_  @#  @|   @!   @;   @:   @?
                         _             spc             _
             )

             (deflayer navigation
               M-1  M-2  M-3  M-4  M-5  lrld M-6  M-7  M-8  M-9  M-0
          tab  @pad @cls bck  fwd  XX        home pgdn pgup end  @run
          esc   @all @sav S-tab tab XX        lft  down up   rght @fun
                 @ndo @cut @cpy @pst XX    _   @mwl @mwd @mwu @mwr XX
                         del             _             esc
             )
             (defalias run M-x ) ;; run = hyprland rofi keybind

             (defalias
               std (layer-switch base)
               pad (layer-switch numpad)

               fun (layer-while-held funpad)

               ;; Mouse wheel emulation
               mwu (mwheel-up    50 120)
               mwd (mwheel-down  50 120)
               mwl (mwheel-left  50 120)
               mwr (mwheel-right 50 120)
             )

             ;; NumPad
             (deflayer numpad
               _    _    _    _    _     _   _    _    _    _    _
          tab  XX   home up   end  pgup      @/   @7   @8   @9   XX
          esc   XX   lft  down rght pgdn      @-   @4   @5   @6   @0
                 XX   XX   XX   XX   XX    _   @,   @1   @2   @3   @.
                         @std           @nbs           @std
             )

             ;; function keys
             (deflayer funpad
          tab XX   XX   XX   XX   XX   XX   XX   XX   XX   XX   XX
               f1   f2   f3   f4   XX        XX   XX   XX   XX   XX
            esc f5   f6   f7   f8   XX        XX   lctl lalt lmet _
                 f9   f10  f11  f12  XX   XX   XX   XX   XX   XX   XX
                         _               _             _
             )  


             ;; Azerty Windows/Linux aliases
             ;; Works with AZERTY-fr. Needs a couple tweaks for the Belgian and Mac variants.

             ;; Navigation layer
             (defalias

               all C-q
               sav C-s
               cls C-z
               ndo C-w
               cut C-x
               cpy C-c
               pst C-v

               0 S-0
               1 S-1
               2 S-2
               3 S-3
               4 S-4
               5 S-5
               6 S-6
               7 S-7
               8 S-8
               9 S-9
               , m
               . S-,
             )

             ;; Symbols layer
             (defalias
              dq (unicode r#"""#)
               ^  (macro [ spc)
               <  <
               >  S-<
               $  ]
               %  S-'
               @  AG-0
               &  1
               *  \
               '  4
               `  (macro AG-7 spc)

               {  AG-4
               pl 5
               pr -
               }  AG-=
               =  =
               \  AG-8
               +  S-=
               -  6
               /  S-.
               ''' 3

               ~  (macro AG-2 spc)
               [  AG-5
               ]  AG--
               _  8
               #  AG-3
               |  AG-6
               !  /
               ;  ,
               :  .
               ?  S-m
               )

               ;; NumRow layer
               (defalias

               s0 0
               s1 1
               s2 2
               s3 3
               s4 4
               s5 5
               s6 6
               s7 7
               s8 8
               s9 9
               nbs (unicode  ) ;; narrow non-break space

               dk1 XX
               dk2 XX
               dk3 XX
               dk4 XX
               dk5 XX
               )

        '';
      };
    };
  };
}
