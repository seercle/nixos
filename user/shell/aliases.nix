{ pkgs, ... }:
{  
  home.shellAliases = {
    hms = "home-manager switch --flake /etc/nixos";
    nrs = "sudo nixos-rebuild switch --flake /etc/nixos";
    ls = "eza --icons -l -T -L=1 --group-directories-first";
    grep = "rg";
    htop = "btm";
    find = "fd";
    neofetch = "fastfetch";
    gitfetch = "onefetch";
    cat = "bat";
  };
  programs.zoxide = {
    enable = true;
    options = ["--cmd cd"];
  };
  home.packages = with pkgs; [
    eza       #better ls 
    ripgrep   #faster grep
    bottom    #better htop
    fd        #better find
    fastfetch #faster neofetch
    onefetch  #git fetch
    bat       #better cat
  ];
}

