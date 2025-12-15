{
  pkgs,
  hostname,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.hostName = hostname;
  programs = {
    nix-ld.enable = true;
  };
  environment.systemPackages = with pkgs; [
    home-manager
    wget
    tldr
    tree
    steam-run
    dig
    toybox
    htop
  ];
  nixpkgs.config.allowUnfree = true;
}
