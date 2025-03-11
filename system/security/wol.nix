{ lib, config,... }:
{
  options.wol.interface = lib.mkOption {
    type = lib.types.str;
  };
  
  config = {
    networking.interfaces.${config.wol.interface}.wakeOnLan.enable = true;
  };
}
