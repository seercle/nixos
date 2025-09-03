{ user,...}:
{
  programs.home-manager.enable = true;
  home.username = user;
  home.homeDirectory = /home/${user};
  nixpkgs.config.allowUnfree = true;
}
