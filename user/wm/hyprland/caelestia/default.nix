{pkgs, config, pkgsUnstable, ...}:
{
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
  ];
  programs.caelestia = {
    enable = true;
    cli.enable = true;
    settings = {
      launcher.actionPrefix = "<";
      bar.status = {
        showKbLayout = true;
      };
    };
  };
  home.file = {
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/user/wm/hyprland/caelestia/hypr;
  };
}
