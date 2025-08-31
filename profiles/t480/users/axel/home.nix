{ config, pkgs, caelestia-shell, caelestia-cli, system, ... }:
{
  imports = [
    ../../../../user/app/git
    ../../../../user/shell/fish
    ../../../../user/shell/aliases
    ../../../../user/shell/foot
    ../../../../user/shell/starship
    ../../../../user/wm/hyprland/caelestia
  ];
  home.packages = with pkgs; [
    zed-editor
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
