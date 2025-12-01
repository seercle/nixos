{
  pkgs,
  hostname,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.hostName = hostname;
  environment.systemPackages = with pkgs; [
    git
    home-manager
    wget
    tldr
    tree
    steam-run
    dig
    toybox
  ];
  nixpkgs.config.allowUnfree = true;
}
