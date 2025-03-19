{pkgs, ...}:
{
  programs.fish.enable = true;
  users.users.william = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBImNr8lQYL9vG3TfamWzfuUC6xX/kF2bRdhE3h8U98G axel.vivenot@outlook.fr"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINDffWe7kGAcZIQSZ9tcKwNyWEe9lRXYPMBmEvzlH85I william.driot@telecom-paris.fr"
    ];
  };
}
