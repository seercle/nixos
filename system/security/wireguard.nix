{ lib, config, pkgs, ... }:
with lib;
with lib.types;
{
  options.wireguard.port = mkOption {
    type = int;
  };
  options.wireguard.externalInterface = mkOption {
    type = str;
  };
  options.wireguard.privateKeyFile = mkOption {
    type = str;
  };
  options.wireguard.ips = mkOption {
    type = listOf str;
  };
  options.wireguard.peers = mkOption {
    type = listOf (submodule {
      options = {
        publicKey = mkOption {
          type = str;
        };
        allowedIPs = mkOption {
          type = listOf str;
        };
      };
    });
  };

  config = {
    networking.nat.enable = true;
    networking.firewall.allowedUDPPorts = [config.wireguard.port];
    networking.nat.externalInterface = config.wireguard.externalInterface;
    networking.nat.internalInterfaces = [ "wg0" ];
    environment.systemPackages = [ pkgs.wireguard-tools ];
    networking.wireguard.interfaces = {
      wg0 = {
        ips = config.wireguard.ips;
        listenPort =  config.wireguard.port;
        privateKeyFile = config.wireguard.privateKeyFile;
        peers = config.wireguard.peers;
      };
    };
  };
}
