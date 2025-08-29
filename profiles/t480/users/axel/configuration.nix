{pkgs, ...}:
{
  programs.fish.enable = true;
  users.users.axel = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    homeMode = "770";
    shell = pkgs.fish;
  };
  services.greetd.settings.default_session.user = "axel";
}
