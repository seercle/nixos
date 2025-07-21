{ lib, config,... }:
let
    service = "wol";
    cfg = config.${service};
in {
{
  options.${service} = with lib; {
    enable = mkEnableOption {
      description = "Enable Wake-on-LAN for a specific network interface";
    };
    interface = mkOption {
      type = types.str;
      description = "Network interface to enable Wake-on-LAN on";
    };
  };
  config = lib.mkIf cfg.enable {
    networking.interfaces.${config.wol.interface}.wakeOnLan.enable = true;
  };
}
