{ config, pkgs, ... }:
{
  imports = [
    ../../../../user/app/git.nix
    ../../../../user/shell/fish.nix
    ../../../../user/shell/aliases.nix
    ../../../../user/shell/starship/starship.nix
  ];
  programs.thefuck = {
    enable = true;
  };
  git.userName = "Hy3z";
  git.userEmail = "axel.vivenot@outlook.fr";
  home.packages = with pkgs; [
    tldr
    bun
    nodejs_22
    tree
    wget
    openssl
    nix-prefetch-git
  ];
}
