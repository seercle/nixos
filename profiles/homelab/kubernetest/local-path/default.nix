{...}:
{
services.k3s.manifests = {
  "local-path-storage-prereq".source = ./local-path-storage-prereq.yaml;
  "local-path-storage-hdd".source = ./local-path-storage-hdd.yaml;
  "local-path-storage-ssd".source = ./local-path-storage-ssd.yaml;
};
}
