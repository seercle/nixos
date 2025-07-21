{
  description = "a general flake";

  inputs = {
    nixpkgs-24-05.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-24-05";
    };
  };
  outputs = inputs@{self, nixpkgs-24-05, nixpkgs-unstable, home-manager,...}:

  let
    profile = "homelab"; #profile to select, must be contained in the profiles directory
    hostname = "homelab";
    system = "x86_64-linux";
    users = ["axel" "william"]; #users to select, must be contained in the users directory of the profile directory
  in {
    homeConfigurations = builtins.listToAttrs (builtins.map(user: {
      name = user;
      value = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs-24-05.legacyPackages.${system};
        modules = [
          ./home.nix
          ./profiles/${profile}/home.nix
          ./profiles/${profile}/users/${user}/home.nix
        ];
        extraSpecialArgs = {
          inherit user;
        };
      };
    }) users);

    nixosConfigurations.${hostname} = nixpkgs-24-05.lib.nixosSystem {
      system = system;
      modules = [
        ./configuration.nix
        ./profiles/${profile}/configuration.nix
      ] ++ builtins.map (username: ./profiles/${profile}/users/${username}/configuration.nix) users;
      specialArgs = {
        inherit users hostname;
        unstablePkgs = nixpkgs-unstable.legacyPackages.${system};
        unstableModules = nixpkgs-unstable.lib.nixosSystemModules;
      };
    };
  };
}
