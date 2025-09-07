{ pkgs, pkgsUnstable, ... }:
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
    ../../../../user/shell/direnv
  ];
  home.packages = with pkgs; [
    pkgsUnstable.zed-editor
    bitwarden-desktop
    thunderbird
    cloc
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
