{ config, pkgs, ... }:
{
  imports = [
    ../../../../user/app/git
    ../../../../user/shell/fish
    ../../../../user/shell/aliases
    ../../../../user/shell/starship
  ];
  programs = {
    thefuck.enable = true;
    zed-editor = {
      enable = true;
      package = pkgs.zed-editor;
    };
  };
  git.userName = "seercle";
  git.userEmail = "notseercle@gmail.com";
  home.packages = with pkgs; [
    tldr
    tree
  ];

}
