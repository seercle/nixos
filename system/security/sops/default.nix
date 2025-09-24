{ pkgs, lib, config, ... }:
let
  service = "_sops";
  cfg = config.${service};
in
{
  options.${service} = with lib; {
    keyFile = mkOption {
      type = types.str;
    };
  };
  config = {
    environment.systemPackages = with pkgs; [
      sops
    ];
    sops = {
      age.keyFile = cfg.keyFile;
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";
    };
  };
}
