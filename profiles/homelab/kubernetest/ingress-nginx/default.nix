{...}:
{
  services.k3s.manifests = {
    "ingress-nginx".source = ./ingress-nginx.yaml;
    "clusterissuer-letsencrypt-staging-http01.yaml".source = ./clusterissuer-letsencrypt-staging-http01.yaml;
    "clusterissuer-letsencrypt-prod-http01.yaml".source = ./clusterissuer-letsencrypt-prod-http01.yaml;
 };
}
