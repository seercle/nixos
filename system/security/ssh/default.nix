
{ lib, config, ... }:
let
    service = "ssh";
    cfg = config.${service};
in {
  options.${service} = with lib; {
    port = mkOption {
      type = types.int;
      default = 22;
      description = "Port for SSH connections.";
    };
  };
  config = {
    services.openssh = {
      enable = true;
      ports = [ cfg.port ];
    };
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
