{ pkgs, vpnSettings, ... }:
{
  networking.nat.enable = true;
  networking.firewall.allowedUDPPorts = [vpnSettings.port];
  networking.nat.externalInterface = vpnSettings.externalInterface;
  networking.nat.internalInterfaces = [ "wg0" ];
  environment.systemPackages = [ pkgs.wireguard-tools ];
  networking.wireguard.interfaces = {
    wg0 = {
      ips = vpnSettings.ips;
      listenPort =  vpnSettings.port;
      privateKeyFile = vpnSettings.privateKeyFile;
      peers = vpnSettings.peers;
    };
  };
}
