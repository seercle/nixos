{ profile, pkgs, ... }:
{
  home.shellAliases = {
    hms = "home-manager switch --flake /etc/nixos/profiles/${profile}";
    nrs = "sudo nixos-rebuild switch --flake /etc/nixos/profiles/${profile}";
    ngc = "nixos-generate-config --dir /etc/nixos/profiles/${profile}";
    nfu = "nix flake update --flake /etc/nixos/profiles/${profile}";

    ga = "git add .";
    gc = "git commit -am";
    gp = "git push";
    gl = "git pull";
    gs = "git status";
    gd = "git diff";

    ls = "eza --icons -l -T -L=1 --group-directories-first";
    grep = "rg";
    htop = "btm";
    find = "fd";
    neofetch = "fastfetch";
    gitfetch = "onefetch";
    cat = "bat";

    s = "sudo";
    k = "kubectl";
    zed = "zeditor";
  };
  programs.zoxide = {
    enable = true;
    options = ["--cmd cd"];
  };
  home.packages = with pkgs; [
    eza
    ripgrep
    bottom
    fd
    fastfetch
    onefetch
    bat
  ];
}
