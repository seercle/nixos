{
  pkgs,
  config,
  lib,
  ...
}: let
  service = "podman";
  cfg = config.${service};
in {
  options.${service} = with lib; {
    users = mkOption {
      type = types.listOf types.str;
    };
  };
  config = {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
    users.users = builtins.listToAttrs (builtins.map (username: {
        name = username;
        value = {extraGroups = ["podman"];};
      })
      cfg.users);
    environment.systemPackages = with pkgs; [
      podman-compose
    ];
  };
}
