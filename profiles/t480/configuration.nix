{ pkgs, nixos-hardware, ... }:
let

in {
  imports = [
    ../../system/security/greetd
    ../../system/security/sops
    ../../system/wm/hyprland
    ../../system/wm/gnome
    ../../system/app/localsend
    ../../system/app/thunar
    ../../system/app/pipewire
    nixos-hardware.nixosModules.lenovo-thinkpad-t480s
  ];
  greetd.command = "Hyprland";
  _sops.keyFile = "/home/axel/.config/sops/age/keys.txt";
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  programs = {
    nix-ld.enable = true;
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
  networking.firewall.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
}
