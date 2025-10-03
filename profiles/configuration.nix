{
  pkgs,
  hostname,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.hostName = hostname;
  environment.systemPackages = with pkgs; [
    home-manager
  ];
  nixpkgs.config.allowUnfree = true;
}
