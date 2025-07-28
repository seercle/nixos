{...}:
{
  services.k3s.manifests = {
    "ingress-nginx".source = ./ingress-nginx.yaml;
    "clusterissuer-letsencrypt-http01".source = ./clusterissuer-letsencrypt-http01.yaml;
 };
}
