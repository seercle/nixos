{ lib, config, pkgs, ... }:
let
  service = "docker";
  cfg = config.${service};
in
{
  options.${service} = with lib; {
    usernames = mkOption {
      type = types.listOf types.str;
    };
  };
  config = {
    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
    };

    users.users = builtins.listToAttrs(builtins.map(username: {
      name = username;
      value = {extraGroups = ["docker"];};
    }) cfg.usernames);

    environment.systemPackages = with pkgs; [
      docker
      docker-compose
      compose2nix
    ];
  };
}
