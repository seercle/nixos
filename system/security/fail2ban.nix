{ pkgs, lib, ... }:
let
  service = "fail2ban";
  cfg = config.${service};
in
{
  options.${service} = with lib; {
    enable = mkEnableOption {
        description = "Enable ${service}";
    };
  };
  config = lib.mkIf cfg.enable {
    services.fail2ban = {
        enable = true;
        extraPackages = [pkgs.ipset];
        banaction = "iptables-ipset-proto6-allports";
        # Ban IP after 3 failures
        maxretry = 3;
        ignoreIP = [];
        bantime = "24h"; # Ban IPs for one day on the first ban
        bantime-increment = {
        enable = true; # Enable increment of bantime after each violation
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h"; # Do not ban for more than 1 week
        overalljails = true; # Calculate the bantime based on all the violations
        };
    };
  }
}
