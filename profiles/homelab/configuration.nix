{ config, lib, pkgs, usernames, systemSettings, vpnSettings, ... }:
{
  imports = [
    ../../system/security/wireguard.nix
    ../../system/security/ssh.nix
    ../../system/security/wol.nix
    ../../system/security/fail2ban.nix
    ../../system/app/docker.nix
    ../../system/app/pelican.nix    
  ]; 
  environment.systemPackages = with pkgs; [
    git
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true; 
  
  networking.firewall.enable = true; #enable firewall 
  networking.firewall.allowedTCPPorts = [80 443]; #open ports for applications and acme (80, 443)

  security.acme = {
    acceptTerms = true;
    defaults.email = "axel.vivenot@outlook.fr";
  };
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = 
      let 
        SSL = {
          enableACME = true;
          forceSSL = true;
        };
      in  {
        "vw.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://192.168.1.9:1080";
        };});
        "authentik.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://192.168.1.9:2080";
          proxyWebsockets = true;
        };});
        "nextcloud.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://192.168.1.9:3080";
        };});
        "gitlab.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://192.168.1.9:4080";
        };});
        "portainer.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "https://192.168.1.9:5443";
        };});
        "pufferpanel.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://192.168.1.9:6080";
          proxyWebsockets = true;
        };});
        "obsidian.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://localhost:7984";
          proxyWebsockets = true;
        };});
        "emqx.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://localhost:8183";
          proxyWebsockets = true;
        };});
        "pb.teleguessr.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://localhost:9090";
          proxyWebsockets = true;
        };});
        "teleguessr.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://localhost:10000";
          proxyWebsockets = true;
        };});
	"bulle.vivenot.dev" = (SSL // {locations."/" = {
	  proxyPass = "http://localhost:8000";
	  proxyWebsockets = true;
	};});
        "minio.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://localhost:11900";
          proxyWebsockets = true;
        };});
        "ui.minio.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://localhost:11901";
          proxyWebsockets = true;
        };});
    };
  };
}

