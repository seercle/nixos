{
  config,
  self,
  pkgs,
  users,
  ...
}: let
  secrets = config.sops.secrets;
in {
  imports = [
    ../../system/kubernetes
    ../../system/security/wireguard
    ../../system/security/ssh
    ../../system/security/fail2ban
    ../../system/security/sops
    ../../system/virtualisation/docker
    ../../system/custom/pedantix-solver
  ];
  _sops.keyFile = "/root/.config/sops/age/nixos.txt";
  sops.secrets = {
    WG_PRIVATE_KEY = {
      sopsFile = ./secrets/sops.yaml;
      format = "yaml";
      key = "WIREGUARD_PRIVATE_KEY";
    };
    K3S_TOKEN = {
      sopsFile = ./secrets/sops.yaml;
      format = "yaml";
      key = "K3S_TOKEN";
    };
  };

  wireguard = {
    port = 51820;
    externalInterface = "enp3s0";
    privateKeyFile = secrets.WG_PRIVATE_KEY.path;
    ips = ["10.0.0.1/32"];
    peers = [
      {
        publicKey = "uh+Vruyi8N+ZoZ8tP2QXMJNotKBe3s2pMB7DsFhfbXw=";
        allowedIPs = ["10.0.0.2/32"];
      }
    ];
  };
  ssh.port = 44;
  docker.users = users;

  networking.interfaces."enp3s0".wakeOnLan.enable = true;
  programs = {
    nix-ld.enable = true;
  };

  pedantix-solver = {
    enable = true;
    path = "/home/axel/ssd/pedantix-solver";
    shellPath = "./shell.nix";
    filePath = "./solver.py";
    logPath = "./job.log";
  };

  environment.systemPackages = with pkgs; [
    git
    filebrowser
    tree
  ];

  system.stateVersion = "24.05";
  time.timeZone = "Europe/Paris";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.firewall.enable = true;
  networking.networkmanager.enable = true;

  system.autoUpgrade = {
    enable = true;
    flake = self.outPath;
    flags = [
      "-L"
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = secrets.K3S_TOKEN.path;
    extraFlags = toString [
      "--cluster-init"
      "--write-kubeconfig-mode \"0644\""
      "--disable traefik"
      "--disable local-storage"
      "--disable metrics-server"
      "--disable helm-controller"
      "--flannel-ipv6-masq"
      "--cluster-cidr=fd00:70:80::/104"
      "--service-cidr=fd00:70:80:99::/112"
      "--kube-controller-manager-arg=\"--node-cidr-mask-size-ipv6=120\""
      "--node-ip=2a02:8428:ea60:c001:9d89:cb1e:edb6:c978"
    ];
  };
}
