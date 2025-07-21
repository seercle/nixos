{ config, pkgs, ... }:
{
  imports = [
    ../../../../user/shell/fish
    ../../../../user/shell/aliases
#    ../../../../user/shell/starship
    ../../../../user/app/git
  ];
  git.userName = "SandwichGouda";
  git.userEmail = "william.driot@gmail.com";
  home.packages = with pkgs; [
    tmux
    screen
    file
    nodejs_22
    unzip
    tldr
    inkscape
    python313
  ];
}
