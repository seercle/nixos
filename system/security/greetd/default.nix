{ pkgs, config, lib, ... }:
let
  service = "greetd";
  cfg = config.${service};
in
{
  options.${service} = with lib; {
    command = mkOption {
      type = types.str;
      description = "Command to execute";
    };
  };
  config = {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${cfg.command}";
          user = "greeter";
        };
      };
    };
  };
}
