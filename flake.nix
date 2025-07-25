
{
  description = "a general flake";

  inputs = {
    nixpkgs-24-05.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-25-05.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager-24-05 = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-24-05";
    };
    sops-nix-24-05 = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-24-05";
    };
  };
  outputs = inputs@{self, nixpkgs-24-05, nixpkgs-25-05, nixpkgs-unstable, home-manager-24-05, sops-nix-24-05, ...}:

  let
    getPkgs = some_nixpkgs: some_nixpkgs.legacyPackages.${system};

    profile = "homelab"; #profile to select, must be contained in the profiles directory
    hostname = "homelab";
    system = "x86_64-linux";
    users = ["axel" "william"]; #users to select, must be contained in the users directory of the profile directory
    nixpkgs = nixpkgs-24-05;
    home-manager = home-manager-24-05;
    sops-nix = sops-nix-24-05;
    allPkgs = {
      pkgs24-05 = getPkgs nixpkgs-24-05;
      pkgs25-05 = getPkgs nixpkgs-25-05;
      pkgsUnstable = getPkgs nixpkgs-unstable;
    };
  in {
    homeConfigurations = builtins.listToAttrs (builtins.map(user: {
      name = user;
      value = home-manager.lib.homeManagerConfiguration {
        pkgs = getPkgs nixpkgs-24-05;
        modules = [
          ./home.nix
          ./profiles/${profile}/home.nix
          ./profiles/${profile}/users/${user}/home.nix
        ];
        extraSpecialArgs = {
          inherit user;
        } // allPkgs;
      };
    }) users);
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [
        ./configuration.nix
        ./profiles/${profile}/configuration.nix
        sops-nix.nixosModules.sops
      ] ++ builtins.map (username: ./profiles/${profile}/users/${username}/configuration.nix) users;
      specialArgs = {
        inherit users hostname;
      } // allPkgs;
    };
  };
}
