{system, winapps, ...}:
{
  environment.systemPackages = [
    winapps.packages."${system}".winapps
    winapps.packages."${system}".winapps-launcher
  ];
}
