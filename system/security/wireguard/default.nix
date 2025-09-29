{ lib, config, pkgs, ... }:
let
    service = "wireguard";
    cfg = config.${service};
in
{
  options.${service} = with lib; {
    port = mkOption {
      type = types.int;
    };
    externalInterface = mkOption {
      type = types.str;
    };
    privateKeyFile = mkOption {
      type = types.str;
    };
    ips = mkOption {
      type = types.listOf types.str;
    };
    peers = mkOption {
      type = types.listOf (types.submodule {
        options = {
          publicKey = mkOption {
            type = types.str;
          };
          allowedIPs = mkOption {
            type = types.listOf types.str;
          };
          endpoint = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
        };
      });
    };
  };


  config = {
    networking = {
      firewall.allowedUDPPorts = [cfg.port];
      nat = {
        enable = true;
        externalInterface = cfg.externalInterface;
        internalInterfaces = [ "wg0" ];
      };
      wireguard.interfaces."wg0" = {
        ips = cfg.ips;
        listenPort =  cfg.port;
        privateKeyFile = cfg.privateKeyFile;
        peers = cfg.peers;
        #dynamicEndpointRefreshSeconds = 60;
      };
    };
    environment.systemPackages = [ pkgs.wireguard-tools ];
  };
}
