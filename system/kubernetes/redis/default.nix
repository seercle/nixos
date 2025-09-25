{pkgs25_05, ...}:
{
  environment.systemPackages = with pkgs25_05; [
    redis
  ];
}
