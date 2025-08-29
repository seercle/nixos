{ config, lib, pkgs, users, nixpkgs, caelestia-shell, pkgsUnstable, ... }:
let

in {
  imports = [
    ../../system/app/docker
    ../../system/app/nix-ld
    #../../system/kubernetes
    ../../system/wm/hyprland
    ../../system/wm/gnome
  ];
  docker = {
   enable = true;
   usernames = users;
  };
  nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    git
    chromium
    caelestia-shell.packages.x86_64-linux.with-cli
    hyprland
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    hyprpicker
    hypridle
    wl-clipboard
    cliphist
    bluez
    inotify-tools
    pkgsUnstable.app2unit
    wireplumber
    trash-cli
    foot
    fish
    fastfetch
    starship
    btop
    jq
    socat
    imagemagick
    curl
    adw-gtk3
    papirus-icon-theme
    libsForQt5.qt5ct
    kdePackages.qt6ct
    nerd-fonts.jetbrains-mono
  ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "axel";
      };
    };
  };
  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
  		  exo
  		  mousepad
  		  thunar-archive-plugin
  		  thunar-volman
  		  tumbler
      ];
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
  		Enable = "Source,Sink,Media,Socket";
  		Experimental = true;
    };
  };
  services = {
    pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
    };
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
