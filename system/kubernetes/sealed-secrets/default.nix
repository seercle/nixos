{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kubeseal
  ];
}
