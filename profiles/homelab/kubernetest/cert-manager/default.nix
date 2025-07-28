{...}:
{
services.k3s.manifests = {
  "cert-manager".source = ./cert-manager.yaml;
};
}
