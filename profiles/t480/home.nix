{pkgs, ...}: {
  home.stateVersion = "23.05";
  #home.packages = with pkgs; [
  #  librsvg
  #];
  #gtk = {
  #  enable = true;
  #  iconTheme = {
  #    name = "Papirus-Dark";
  #    package = pkgs.papirus-icon-theme;
  #  };
  #  theme = {
  #    name = "Adwaita-dark";
  #    package = pkgs.gnome-themes-extra;
  #  };
  #  gtk3.extraConfig = {
  #    gtk-application-prefer-dark-theme = 1;
  #  };
  #};
  #
  ## Ensure dconf is enabled so apps can read these settings
  #dconf.settings = {
  #  "org/gnome/desktop/interface" = {
  #    color-scheme = "prefer-dark";
  #  };
  #};
}
