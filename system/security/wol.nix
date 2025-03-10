{ systemSettings, ... }:
{
  networking.interfaces.${systemSettings.wolInterface}.wakeOnLan.enable = true;
}
