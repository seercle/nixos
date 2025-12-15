{
  pkgs,
  config,
  pkgsUnstable,
  ...
}: {
  imports = [
    ../../../shell/fish
    ../../../shell/foot
  ];
  home.packages = with pkgs; [
    hyprland
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    hyprpicker
    hypridle
    wl-clipboard
    cliphist
    bluez
    blueman
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
    networkmanagerapplet
    pavucontrol
    mpv
  ];
  programs.caelestia = {
    enable = true;
    cli.enable = true;
    settings = {
      launcher.actionPrefix = "<";
      bar = {
        workspaces = {
          shown = 8;
        };
        status = {
          showAudio = true;
          showKbLayout = true;
        };
        entries = [
          {
            id = "logo";
            enabled = true;
          }
          {
            id = "workspaces";
            enabled = true;
          }
          {
            id = "spacer";
            enabled = true;
          }
          {
            id = "tray";
            enabled = true;
          }
          {
            id = "clock";
            enabled = true;
          }
          {
            id = "statusIcons";
            enabled = true;
          }
          {
            id = "power";
            enabled = true;
          }
        ];
      };
    };
  };
  home.file = {
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/user/wm/hyprland/caelestia/hypr;
  };
}
