
{
  description = "t480 flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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
  };
  outputs = inputs@{self, nixpkgs, home-manager, ...}:

  let
    profile = "homelab";
    hostname = "homelab";
    system = "x86_64-linux";
    users = ["axel" "william"];
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
      };
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
