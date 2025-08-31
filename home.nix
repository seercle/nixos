{ user,...}:
{
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
  home.username = user;
  home.homeDirectory = /home/${user};
  nixpkgs.config.allowUnfree = true;
}
