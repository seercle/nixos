
{
  description = "a general flake";

  inputs = {
    nixpkgs-24-11.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    nixpkgs-25-05.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager-24-11 = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-24-11";
    };
    home-manager-25-05 = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-25-05";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    winapps.url = "github:winapps-org/winapps";
    nix-index-database.url = "github:nix-community/nix-index-database";
  };
  outputs = inputs@{self, spicetify-nix, nixos-hardware, winapps, ...}:

  let
    getPkgs = some_nixpkgs: some_nixpkgs.legacyPackages.${system};
    profile = "t480"; #profile to select, must be contained in the profiles directory
    hostname = "t480";
    system = "x86_64-linux";
    users = ["axel"]; #users to select, must be contained in the users directory of the profile directory
    nixpkgs = inputs.nixpkgs-25-05;
    home-manager = inputs.home-manager-25-05;
    allPkgs = {
      pkgs24-11 = getPkgs inputs.nixpkgs-24-11;
      pkgs25-05 = getPkgs inputs.nixpkgs-25-05;
      pkgsUnstable = getPkgs inputs.nixpkgs-unstable;
    };
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [
        ./configuration.nix
        ./profiles/${profile}/configuration.nix
        inputs.sops-nix.nixosModules.sops
      ] ++ builtins.map (username: ./profiles/${profile}/users/${username}/configuration.nix) users;
      specialArgs = {
        inherit self nixos-hardware winapps users hostname system nixpkgs;
      } // allPkgs;
    };
    homeConfigurations = builtins.listToAttrs (builtins.map(user: {
      name = user;
      value = home-manager.lib.homeManagerConfiguration {
        pkgs = getPkgs nixpkgs;
        modules = [
          ./home.nix
          ./profiles/${profile}/home.nix
          ./profiles/${profile}/users/${user}/home.nix
          inputs.caelestia-shell.homeManagerModules.default
          inputs.nix-index-database.homeModules.nix-index
        ];
        extraSpecialArgs = {
          inherit spicetify-nix user nixpkgs;
        } // allPkgs;
      };
    }) users);
  };
}
