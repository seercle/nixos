{ config, pkgs, ... }:
{
  imports = [
    ../../../../user/shell/fish.nix
    ../../../../user/shell/aliases.nix
#    ../../../../user/shell/starship/starship.nix
    ../../../../user/app/git.nix
  ];
  git.userName = "SandwichGouda";
  git.userEmail = "william.driot@gmail.com";
  home.packages = with pkgs; [
    tmux
    screen
    file
    nodejs_22
    unzip
  ];
}
