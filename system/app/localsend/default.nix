{ pkgs, ... }:
{
    networking.firewall.allowedTCPPorts = [53317];
    networking.firewall.allowedUDPPorts = [53317];
    environment.systemPackages = with pkgs; [
      localsend
    ];
}
