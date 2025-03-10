{ pkgs, usernames, ... }:
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  #add all users to the docker group
  users.users = builtins.listToAttrs(builtins.map(username: {
    name = username; 
    value = {extraGroups = ["docker"];};
  }) usernames);
  
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];
}
