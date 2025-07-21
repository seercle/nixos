{ lib, config, pkgs, ... }:
let
  service = "nix-ld";
  cfg = config.${service};
in
{
  options.${service} = with lib; {
    enable = mkEnableOption {
      description = "Enable Nix LD service for running unpatched dynamically linked binaries";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
  };
}
