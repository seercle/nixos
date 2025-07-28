{...}:
{
  systemd.tmpfiles.rules = [
      "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
    ];
  virtualisation.docker.logDriver = "json-file";
  services.openiscsi = {
      enable = true;
      name = "iqn.2016-04.com.open-iscsi:${meta.hostname}";
  };
  services.k3s.manifests = {
    "longhorn".source = ./longhorn.yaml;
  };
}
