{pkgs, spicetify-nix, ...}:
let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    spicetify-nix.homeManagerModules.default
  ];
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
    ];
    theme = {
      name = "caelestia";
      src = pkgs.fetchFromGitHub {
        owner = "caelestia-dots";
        repo = "caelestia";
        rev = "d297795";
        hash = "sha256-Yp9U+gq8zXlG9rH7QgYTc+IzWSwyoOXzbQ35htdFGAU=";
      };
    };
  };
}
