{ ... }:
{
  services.k3s.manifests = {
    "authentik".source = ./authentik.yaml;
  };
}
