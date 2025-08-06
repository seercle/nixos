{pkgs, hostname, ...}:
{
  systemd.tmpfiles.rules = [
      "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
    ];
  virtualisation.docker.logDriver = "json-file";
  services.openiscsi = {
      enable = true;
      name = "iqn.2020-08.org.linux-iscsi.initiatorhost:${hostname}";
  };
  environment.systemPackages = with pkgs; [
    nfs-utils
  ];
}
