{ config, lib, pkgs, users, nixpkgs, ... }:
let

in {
  imports = [
    ../../system/app/docker
    ../../system/app/nix-ld
    ../../system/security/greetd

    #add enable option to the rest
    ../../system/wm/hyprland
    ../../system/wm/gnome
    ../../system/app/thunar
    ../../system/app/pipewire
    ../../system/hardware/bluetooth
    ../../system/hardware/graphics
  ];
  docker = {
   enable = true;
   usernames = users;
  };
  nix-ld.enable = true;
  greetd = {
    enable = true;
    command = "Hyprland";
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
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

}
