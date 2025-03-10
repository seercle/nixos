{ pkgs, ... }:
{  
  home.shellAliases = {
    hms = "home-manager switch --flake /etc/nixos";
    nrs = "sudo nixos-rebuild switch --flake /etc/nixos";
    ls = "eza --icons -l -T -L=1 --group-directories-first";
    #grep = "rg";
    htop = "btm";
    #find = "fd";
    neofetch = "fastfetch";
    gitfetch = "onefetch";
    cat = "bat";
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
  
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    initExtra = ''
    PROMPT=" ◉ %U%F{magenta}%n%f%u@%U%F{blue}%m%f%u:%F{yellow}%~%f
     %F{green}→%f "
    RPROMPT="%F{red}▂%f%F{yellow}▄%f%F{green}▆%f%F{cyan}█%f%F{blue}▆%f%F{magenta}▄%f%F{white}▂%f"
    [ $TERM = "dumb" ] && unsetopt zle && PS1='$ '
    bindkey '^P' history-beginning-search-backward
    bindkey '^N' history-beginning-search-forward
    '';
  };
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };
}

