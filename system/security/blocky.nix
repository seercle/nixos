{ lib, config, ... }:
let
  service = "blocky";
  cfg = config.${service};
in
  {
    options.${service} = with lib; {
      enable = .mkEnableOption {
        description = "Enable ${service}";
      };
      certFile = mkOption {
        type = types.str;
        description = "Path to the certificate file for Blocky.";
      };
      keyFile = mkOption {
        type = types.str;
        description = "Path to the key file for Blocky.";
      };
    };
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [53 853];
    networking.firewall.allowedUDPPorts = [53];
    users.users.blocky = {
      isNormalUser = true;
      extraGroups = ["acme"];
    };
    #users.groups.blocky = {}; #do this if you set 'group = "blocky"' in acme
    services.blocky = {
      enable = true;
      settings = {
        ports.dns = 53; # Port for incoming DNS Queries.
        upstreams.groups.default = [
          "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
        ];
        ports.tls = 853;
        certFile = cfg.certFile;
        keyFile = cfg.keyFile;
        # For initially solving DoH/DoT Requests when no system Resolver is available.
        bootstrapDns = {
          upstream = "https://one.one.one.one/dns-query";
          ips = [ "1.1.1.1" "1.0.0.1" ];
        };
        #Enable blocking of certain domains.
        blocking = {
          blackLists = {
            ads = ["https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/pro.plus.txt"]; #Adblocking
            adult = ["https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/nsfw.txt"]; #Another filter for blocking adult sites
          };
          #Configure what block categories are used
          clientGroupsBlock = {
            default = [ "ads" ];
            kids = [ "ads" "adult" ];
          };
        };
        caching = {
          minTime = "5m";
          maxTime = "30m";
          prefetching = true;
        };
      };
    };
  };
}
