{ lib, config, pkgs, ... }:
let
  service = "docker";
  cfg = config.${service};
in
{
  options.${service} = with lib; {
    enable = mkEnableOption {
      description = "Enable Docker service";
    };
    usernames = mkOption {
      type = types.listOf types.str;
    };
  };
  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
    };

    #add all users to the docker group
    users.users = builtins.listToAttrs(builtins.map(username: {
      name = username;
      value = {extraGroups = ["docker"];};
    }) cfg.usernames);

    environment.systemPackages = with pkgs; [
      docker
      docker-compose
    ];
  };
}
