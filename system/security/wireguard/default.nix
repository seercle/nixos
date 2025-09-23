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
        };
      });
    };
  };


  config = {
    networking.nat.enable = true;
    networking.firewall.allowedUDPPorts = [cfg.port];
    networking.nat.externalInterface = cfg.externalInterface;
    networking.nat.internalInterfaces = [ "wg0" ];
    environment.systemPackages = [ pkgs.wireguard-tools ];
    networking.wireguard.interfaces = {
      wg0 = {
        ips = cfg.ips;
        listenPort =  cfg.port;
        privateKeyFile = cfg.privateKeyFile;
        peers = cfg.peers;
      };
    };
  };
}
