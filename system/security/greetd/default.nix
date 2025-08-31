{ pkgs, config, lib, ... }:
let
  service = "greetd";
  cfg = config.${service};
in
{
  options.${service} = with lib; {
    enable = mkEnableOption {
        description = "Enable ${service}";
    };
    command = mkOption {
      type = types.str;
      description = "Command to execute";
    };
  };
  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };
  };
}
