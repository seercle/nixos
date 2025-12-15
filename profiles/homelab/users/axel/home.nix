{pkgs, ...}: {
  imports = [
    ../../../../user/shell/fish
    ../../../../user/shell/aliases
    ../../../../user/shell/starship
  ];
  programs = {
    tmux = {
      enable = true;
      shell = "${pkgs.fish}/bin/fish";
    };
    git = {
      userName = "seercle";
      userEmail = "notseercle@gmail.com";
    };
  };
  home.packages = with pkgs; [
    bun
    nodejs_22
    openssl
    nix-prefetch-git
    tmux
    python313
    minio-client
  ];
}
