{pkgs, ...}:
{
  programs.fish.enable = true;
  users.users.axel = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    homeMode = "770";
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBImNr8lQYL9vG3TfamWzfuUC6xX/kF2bRdhE3h8U98G accel@arch"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0586lNqfjrj8h/XkPZxQB1OKPNdp2ylr715zrVpEvW axel@t480"
    ];
  };
}
