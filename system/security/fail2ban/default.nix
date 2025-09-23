{ pkgs, ... }:
{
  services.fail2ban = {
    enable = true;
    extraPackages = [pkgs.ipset];
    banaction = "iptables-ipset-proto6-allports";
    maxretry = 3;
    ignoreIP = [];
    bantime = "24h";
    bantime-increment = {
    enable = true;
    multipliers = "1 2 4 8 16 32 64";
    maxtime = "168h";
    overalljails = true;
    };
  };
}
