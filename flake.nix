
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
  };
  outputs = inputs@{self, nixpkgs-24-11, nixpkgs-25-05, nixpkgs-unstable, home-manager-24-11, home-manager-25-05, sops-nix, caelestia-shell, ...}:

  let
    getPkgs = some_nixpkgs: some_nixpkgs.legacyPackages.${system};

    profile = "t480"; #profile to select, must be contained in the profiles directory
    hostname = "t480";
    system = "x86_64-linux";
    users = ["axel"]; #users to select, must be contained in the users directory of the profile directory
    nixpkgs = nixpkgs-25-05;
    home-manager = home-manager-25-05;
    #sops-nix = sops-nix-24-05;
    allPkgs = {
      pkgs24-11 = getPkgs nixpkgs-24-11;
      pkgs25-05 = getPkgs nixpkgs-25-05;
      pkgsUnstable = getPkgs nixpkgs-unstable;
    };
  in {
    homeConfigurations = builtins.listToAttrs (builtins.map(user: {
      name = user;
      value = home-manager.lib.homeManagerConfiguration {
        pkgs = getPkgs nixpkgs;
        modules = [
          ./home.nix
          ./profiles/${profile}/home.nix
          ./profiles/${profile}/users/${user}/home.nix
        ];
        extraSpecialArgs = {
          inherit user nixpkgs caelestia-shell;
        } // allPkgs;
      };
    }) users);
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [
        ./configuration.nix
        ./profiles/${profile}/configuration.nix
        #sops-nix.nixosModules.sops
      ] ++ builtins.map (username: ./profiles/${profile}/users/${username}/configuration.nix) users;
      specialArgs = {
        inherit users hostname nixpkgs caelestia-shell;
      } // allPkgs;
    };
  };
}
