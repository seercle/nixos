{ config, pkgs, ... }:
{
  imports = [
    ../../../../user/app/git
    ../../../../user/shell/fish
    ../../../../user/shell/aliases
    ../../../../user/shell/starship
  ];
  programs.thefuck.enable = true;
  git.userName = "seercle";
  git.userEmail = "axel.vivenot@outlook.fr";
  home.packages = with pkgs; [
    tldr
    bun
    nodejs_22
    tree
    wget
    openssl
    nix-prefetch-git
    tmux
    python313
    minio-client
  ];
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
  };
}
