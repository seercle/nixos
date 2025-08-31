{ config, pkgs, caelestia-shell, caelestia-cli, system, ... }:
{
  imports = [
    ../../../../user/app/git
    ../../../../user/shell/fish
    ../../../../user/shell/aliases
    ../../../../user/shell/foot
    ../../../../user/shell/starship
    ../../../../user/wm/hyprland/caelestia
    ../../../../user/app/spicetify
    ../../../../user/app/vesktop
    ../../../../user/cursor/catppuccin
    ../../../../user/app/btop
  ];
  home.packages = with pkgs; [
    zed-editor-fhs
    bitwarden-desktop
  ];
  programs = {
    thefuck.enable = true;
    /*zed-editor = {
      enable = true;
      package = pkgs.zed-editor;
      };*/
  };
  git.userName = "seercle";
  git.userEmail = "notseercle@gmail.com";

}
