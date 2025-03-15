{ config, pkgs, ... }:
{
  imports = [
    ../../../../user/app/git.nix
    ../../../../user/shell/fish.nix
    #../../../../user/shell/zsh.nix
    ../../../../user/shell/aliases.nix
    ../../../../user/shell/starship/starship.nix
  ];
  git.userName = "Hy3z";
  git.userEmail = "axel.vivenot@outlook.fr";
  home.packages = with pkgs; [
    tldr
    bun
    nodejs_22
    btop
    tree
    wget
    openssl
    nix-prefetch-git
  ];
}
