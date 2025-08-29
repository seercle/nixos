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
    hyprpaper
    wofi
    kitty
  ];
  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          user = username;
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
