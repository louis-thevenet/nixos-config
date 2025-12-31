{ config, lib, ... }:

let
  cfg = config.services.howdy;

  # Helper to add howdy to a PAM service
  addHowdyToPamService = name: {
    ${name}.rules.auth.howdy = lib.mkIf config.security.pam.services.${name}.howdyAuth {
      order = 11900; # Same as fprintd
      control = "sufficient";
      modulePath = "${cfg.package}/lib/security/pam_howdy.so";
    };
  };
in
{
  # Extend PAM services with howdyAuth option
  options.security.pam.services = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.howdyAuth = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            If set, IR camera facial recognition will be used for authentication
            (if Howdy is enabled and your facial models are enrolled).
          '';
        };
      }
    );
  };

  # Configure PAM rules for common services
  # Add more services here as needed
  config.security.pam.services = lib.mkMerge [
    (addHowdyToPamService "login")
    (addHowdyToPamService "sudo")
    (addHowdyToPamService "su")
    (addHowdyToPamService "polkit-1")
    (addHowdyToPamService "swaylock")
    (addHowdyToPamService "greetd")
    (addHowdyToPamService "hyprlock")
  ];
}
