_: {
  services = {
    howdy = {
      enable = true;
      settings = {
        core = {
          abort_if_ssh = true;
        };
        video.dark_threshold = 90;
        video.timeout = 2;
      };
    };

    linux-enable-ir-emitter = {
      enable = true;
    };
  };
}
