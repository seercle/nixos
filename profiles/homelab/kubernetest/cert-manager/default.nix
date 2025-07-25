{...}:
{
services.k3s.manifests = {
  "cert-manager".source = ./cert-manager.yaml;
  "clusterissuer-letsencrypt-http01".source = ./clusterissuer-letsencrypt-http01.yaml;
};
}
