{ pkgs, config, nixos-hardware, ... }:
let
  secrets = config.sops.secrets;
in {
  imports = [
    ../../system/security/greetd
    ../../system/security/sops
    ../../system/security/wireguard
    ../../system/wm/hyprland
    ../../system/wm/gnome
    ../../system/app/thunar
    ../../system/app/pipewire
    nixos-hardware.nixosModules.lenovo-thinkpad-t480s
  ];
  greetd.command = "Hyprland";
  _sops.keyFile = "/home/axel/.config/sops/age/keys.txt";
  sops.secrets = {
    WG_PRIVATE_KEY = {
      sopsFile = ./secrets/sops.yaml;
      format = "yaml";
      key = "WIREGUARD_PRIVATE_KEY";
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
        endpoint = "seercle.com:51820";
      }
    ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  programs = {
    nix-ld.enable = true;
    localsend.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    chromium
    tldr
    tree
    vscode-fhs
  ];

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
  networking.firewall = {
    enable = true;
    #allowedTCPPorts = [ 65535 ];
    #allowedUDPPorts = [ 65535 ];
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
}
