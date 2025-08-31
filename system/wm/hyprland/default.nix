{pkgs, pkgsUnstable, ...}:
{
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    kitty
    wl-clipboard
  ];
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };
}
