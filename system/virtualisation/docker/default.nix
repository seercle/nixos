{
  lib,
  config,
  pkgs,
  ...
}: let
  service = "docker";
  cfg = config.${service};
  #pkgsDocker28_4 =
  #  import (builtins.fetchTarball {
  #    name = "nixpkgs-docker-28.4";
  #    url = "https://github.com/nixos/nixpkgs/archive/870493f9a8cb0b074ae5b411b2f232015db19a65.tar.gz";
  #    sha256 = "045sqv2qym9hmly6c2khpbawwn26084x8lxz7qs0zqd5y9ahdjq4";
  #  }) {
  #    system = builtins.currentSystem or "x86_64-linux";
  #  };
in {
  options.${service} = with lib; {
    users = mkOption {
      type = types.listOf types.str;
    };
  };
  config = {
    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
    };

    users.users = builtins.listToAttrs (builtins.map (username: {
        name = username;
        value = {extraGroups = ["docker"];};
      })
      cfg.users);

    environment.systemPackages = with pkgs; [
      docker
      docker-compose
      compose2nix
    ];
    #environment.systemPackages = with pkgsDocker28_4; [
    #  docker
    #  docker-compose
    #  compose2nix
    #];
  };
}
