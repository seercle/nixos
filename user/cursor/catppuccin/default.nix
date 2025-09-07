{pkgs, ...}:
let
  cfg = ".local/share/icons";
in
{
  home.packages = with pkgs; [
    catppuccin-cursors.mochaDark
  ];
  home.file = {
    "${cfg}/catppuccin-mocha-dark".source = "${pkgs.catppuccin-cursors.mochaDark}/share/icons/catppuccin-mocha-dark-cursors";
  };
}
