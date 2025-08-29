{ config, lib, pkgs, users, nixpkgs, ... }:
let
in {
  imports = [
    ../../system/app/docker
    ../../system/app/nix-ld
    #../../system/kubernetes
    ../../system/app/hyprland
  ];
  docker = {
   enable = true;
   usernames = users;
  };
  nix-ld.enable = true;
  environment.systemPackages = with pkgs; [
    git
    chromium
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
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      libva
			libva-utils
    ];
  };
}
