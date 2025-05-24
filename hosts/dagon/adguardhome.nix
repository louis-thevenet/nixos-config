_:
let
  port = 81;
in
{
  networking.firewall = {
    allowedTCPPorts = [
      # 3000 # initial install
      port # web page
    ];
    allowedUDPPorts = [
      53 # DNS server
    ];
  };
  services.adguardhome = {
    enable = true;
    allowDHCP = true;
    inherit port;
  };
}
