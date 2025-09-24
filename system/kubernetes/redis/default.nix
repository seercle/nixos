{pkgs25-05, ...}:
{
  environment.systemPackages = with pkgs25-05; [
    redis
  ];
}
