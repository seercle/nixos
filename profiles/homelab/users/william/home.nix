{ config, pkgs, ... }:
{
  imports = [
    ../../../../user/shell/fish.nix
    ../../../../user/shell/aliases.nix
#    ../../../../user/shell/starship/starship.nix
  ];
  home.packages = with pkgs; [
    tmux
    screen
    file
    nodejs_22
    unzip
  ];
}
