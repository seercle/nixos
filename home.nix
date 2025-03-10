{ username,...}:
{
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";  
  home.username = username;
  home.homeDirectory = /home/${username};
}
