{user, ...}: {
  programs = {
    home-manager.enable = true;
    pay-respects.enable = true;
    git.enable = true;
  };
  home = {
    username = user;
    homeDirectory = /home/${user};
  };
  nixpkgs.config.allowUnfree = true;
}
