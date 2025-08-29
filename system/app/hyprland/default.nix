{pkgs, ...}:
{
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    waybar.enable = true;
    hyprlock.enable = true;
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
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };
  environment.systemPackages = with pkgs; [
    wget
    unzip
    gum
    rsync
    git
    figlet
    xdg-user-dirs
    hyprland
    hyprpaper
    hyprlock
    hypridle
    hyprpicker
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    noto-fonts-extra
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    libnotify
    kitty
    qt5-wayland
    qt6-wayland
    fastfetch
    eza
    python-pip
    python-gobject
    python-screeninfo
    tumbler
    brightnessctl
    nm-connection-editor
    network-manager-applet
    imagemagick
    jq
    xclip
    kitty
    neovim
    htop
    blueman
    grim
    slurp
    cliphist
    nwg-look
    qt6ct
    waybar
    rofi-wayland
    polkit-gnome
    zsh
    zsh-completions
    fzf
    pavucontrol
    papirus-icon-theme
    breeze
    flatpak
    swaync
    gvfs
    wlogout
    waypaper
    grimblast-git
    bibata-cursor-theme
    pacseek
    otf-font-awesome
    ttf-fira-sans
    ttf-fira-code
    ttf-firacode-nerd
    ttf-dejavu
    nwg-dock-hyprland
    power-profiles-daemon
    python-pywalfox
    vlc
  ];
  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    blueman.enable = true;
    pulseaudio.enable = false;
  };
  zramSwap = {
	  enable = true;
	  priority = 100;
	  memoryPercent = 30;
	  swapDevices = 1;
    algorithm = "zstd";
  };
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
  		Enable = "Source,Sink,Media,Socket";
  		Experimental = true;
    };
  };
}
