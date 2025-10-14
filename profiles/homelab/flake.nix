
{
  description = "homelab flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-25_05.url = "github:nixos/nixpkgs/nixos-25.05";
  };
  outputs = inputs@{self, nixpkgs, home-manager, ...}:

  let
    profile = "homelab";
    hostname = "homelab";
    system = "x86_64-linux";
    users = ["axel" "william"];
    pkgs = {
      pkgs25_05 = inputs.nixpkgs-25_05.legacyPackages.${system};
    };
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        ../configuration.nix
        inputs.sops-nix.nixosModules.sops
      ] ++ builtins.map (username: ./users/${username}/configuration.nix) users;
      specialArgs = {
        inherit self users hostname system nixpkgs;
      } // pkgs;
    };
    homeConfigurations = builtins.listToAttrs (builtins.map(user: {
      name = user;
      value = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ../home.nix
          ./home.nix
          ./users/${user}/home.nix
          inputs.nix-index-database.homeModules.nix-index
        ];
        extraSpecialArgs = {
          inherit profile user nixpkgs;
        };
      };
    }) users);
  };
}
