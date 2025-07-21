{ pkgs, ... }:
let
  catppuccin-fish = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "fish";
    rev = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
    hash = "sha256-Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg=";
  };
in
{
  home.packages = with pkgs; [
    grc
    fzf
  ];
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fish_config theme choose Catppuccin\ Mocha # Select theme
    '';
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }      
      { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
    ];
  };
  #xdg.configFile."fish/themes/Catppuccin Latte.theme".source = "${catppuccin-fish}/themes/Catppuccin Latte.theme";
  xdg.configFile."fish/themes/Catppuccin Mocha.theme".source = "${catppuccin-fish}/themes/Catppuccin Mocha.theme";
  #xdg.configFile."fish/themes/Catppuccin Frappe.theme".source = "${catppuccin-fish}/themes/Catppuccin Frappe.theme";
}

