{ config, lib, pkgs, users, ... }:
let
  #dnsDomain = "dns.vivenot.dev";
  secrets = config.sops.secrets;
  #gitlabPath = "/mnt/sdb1/gitlab";
in {
  imports = [
    ../../system/security/wireguard
    ../../system/security/ssh
    ../../system/security/wol
    ../../system/security/fail2ban
    ../../system/security/sops
    #../../system/security/blocky
    #../../system/security/minio-backup

    ../../system/app/docker
    ../../system/app/pedantix-solver
    ../../system/app/nix-ld
    #../../system/app/gitlab
    #../../system/app/kafka
    #../../system/fonts.nix

    ../../system/kubernetes
  ];
  sops.secrets = {
    WG_PRIVATE_KEY = {};
    /*CLOUDFLARE_DNS_API_TOKEN = {
      sopsFile = ../../system/security/sops/secrets/cloudflare.env;
      format = "dotenv";
      key = "";
    };*/
    /*MINIO_CONFIG = {
      sopsFile = ../../system/security/sops/secrets/minio.json;
      format = "json";
      key = "";
    };*/
  };

  wireguard = {
    enable = true;
    port = 51820;
    externalInterface = "enp4s0";
    privateKeyFile = secrets.WG_PRIVATE_KEY.path;
    ips = ["10.0.0.1/24"];
    peers = [
      {
        publicKey = "xQaF3IfJQvmHEzytEVAG2xBSdn56NsqRXt2eIUGYJRY=";
        allowedIPs = ["10.0.0.2/32"];
      }
    ];
  };
  ssh = {
    enable = true;
    port = 22;
  };
  docker = {
   enable = true;
   usernames = users;
  };
  wol = {
    enable = true;
    interface = "enp4s0";
  };
  fail2ban.enable = true;
  pedantix-solver = {
    enable = true;
    path = "/home/axel/ssd/pedantix-solver";
    shellPath = "./shell.nix";
    filePath = "./solver.py";
    logPath = "./job.log";
  };
  nix-ld.enable = true;
  /*
  minio-backup = {
    enable = false;
    configFile = secrets.MINIO_CONFIG.path;
    #configFile = "/root/minio/config.json";
    calendar = "weekly";
    bucket = "xxgoldenbluexx/hyez";
    files = "/etc/nixos /mnt/sdb1/vaultwarden/vw-data /mnt/sda1/nextcloud/data /mnt/sdb1/gitlab/data/backups";
    prefix = "backup";
    retention = 5;
  };
  blocky = {
    enable = true;
    certFile = "${config.security.acme.certs.${dnsDomain}.directory}/fullchain.pem";
    keyFile = "${config.security.acme.certs.${dnsDomain}.directory}/key.pem";
  };
  kafka = {
    enable = true;
    publicIp = "vivenot.dev";
    textPort = 9092;
    controllerPort = 9093;
  };
  */
  environment.systemPackages = with pkgs; [
    git
    filebrowser
    tree
  ];

  time.timeZone = "Europe/Paris";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.firewall.enable = true; #enable firewall

  /*security.acme = {
    acceptTerms = true;
    defaults.email = "notseercle@gmail.com";
    certs.${dnsDomain} = {
      dnsProvider = "cloudflare";
      environmentFile = secrets.CLOUDFLARE_DNS_API_TOKEN.path; #path to the file with 'CLOUDFLARE_DNS_API_TOKEN=[value]'
    };
  };*/
  /*
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    clientMaxBodySize = "10g";
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
        "minio.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://localhost:11900";
          proxyWebsockets = true;
        };});
        "ui.minio.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://localhost:11901";
          proxyWebsockets = true;
        };});

        "3a.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://localhost:12080";
          proxyWebsockets = true;
        };});

        # Ports 13000-14000 : propriété de william

        "dev.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://localhost:13000";
          proxyWebsockets = true;
        };});
	      "file.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://localhost:13001";
          proxyWebsockets = true;
        };});
	      "filedev.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://localhost:13002";
          proxyWebsockets = true;
        };});
        "setdle.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://localhost:13003";
          proxyWebsockets = true;
        };});

        "kafka.vivenot.dev" = (SSL // {locations."/" = {
          proxyPass = "http://localhost:14080";
          proxyWebsockets = true;
          };})
    };
  };*/
}
