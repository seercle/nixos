{
  pkgs,
  config,
  users,
  nixos-hardware,
  ...
}: let
  secrets = config.sops.secrets;
in {
  imports = [
    ../../system/security/greetd
    ../../system/security/sops
    ../../system/security/wireguard
    ../../system/wm/hyprland
    ../../system/app/thunar
    #../../system/virtualisation/podman
    ../../system/virtualisation/docker
    ../../system/app/pipewire
    ../../system/app/gpu-screen-recorder
    nixos-hardware.nixosModules.lenovo-thinkpad-t480s
  ];

  users.users.axel = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    homeMode = "770";
    shell = pkgs.fish;
  };

  greetd.command = "Hyprland";
  _sops.keyFile = "/home/axel/.config/sops/age/keys.txt";
  sops.secrets = {
    WG_PRIVATE_KEY = {
      sopsFile = ./secrets/sops.yaml;
      format = "yaml";
      key = "WIREGUARD_PRIVATE_KEY";
    };
    TP_VPN_CONFIG = {
      sopsFile = ./secrets/tp_sops.ovpn;
      format = "binary";
    };
    TP_VPN_USERPASS = {
      sopsFile = ./secrets/tp_userpass.ovpn;
      format = "binary";
    };
  };
  wireguard = {
    port = 51820;
    externalInterface = "wlp61s0";
    privateKeyFile = secrets.WG_PRIVATE_KEY.path;
    ips = ["10.0.0.2/32"];
    peers = [
      {
        publicKey = "fS7oBpMhjao5KZFjlSZe42Fbet5aIWJRLzZPocaXjRQ=";
        allowedIPs = ["10.0.0.1/32"];
        endpoint = "homelab.seercle.com:51820";
      }
    ];
  };
  docker.users = users;
  #podman.users = users;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services = {
    upower.enable = true;
    blueman.enable = true;
    openvpn.servers = {
      tpVPN = {
        config = ''
          config ${secrets.TP_VPN_CONFIG.path}
          auth-user-pass  ${secrets.TP_VPN_USERPASS.path}
        '';
        autoStart = false;
      };
    };
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };

  programs = {
    dconf.enable = true;
    localsend.enable = true;
    fish.enable = true;
  };

  system.stateVersion = "25.05";
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };
  console.keyMap = "fr";
  networking = {
    firewall = {
      enable = true;
      # Open ports for some application that might require to open a TCP port
      # Do not use them for something permanent
      allowedTCPPortRanges = [
        {
          from = 10100;
          to = 10110;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 10100;
          to = 10110;
        }
      ];
    };
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
  };
  security.polkit.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };
}
