
{ lib, config, ... }:
let
    service = "ssh";
    cfg = config.${service};
in {
    options.${service} = with lib; {
        enable = mkEnableOption {
            description = "Enable ${service}";
        };
        port = mkOption {
            type = types.int;
            default = 22;
            description = "Port for SSH connections.";
        };
    };
    config = lib.mkIf cfg.enable {
        services.openssh = {
          enable = true;
          ports = [ cfg.port ];
        };
        networking.firewall.allowedTCPPorts = [ cfg.port ];
    };
}
