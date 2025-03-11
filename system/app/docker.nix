{ lib, config, pkgs, ... }:
{
  options.docker.usernames = lib.mkOption {
    type = lib.types.listOf lib.types.str;
  };

  config = {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
    };

    #add all users to the docker group
    users.users = builtins.listToAttrs(builtins.map(username: {
      name = username; 
      value = {extraGroups = ["docker"];};
    }) config.docker.usernames);
  
    environment.systemPackages = with pkgs; [
      docker
      docker-compose
    ];
  };
}
