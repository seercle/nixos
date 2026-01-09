
{
  description = "t480 flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winapps = {
      url = "github:winapps-org/winapps";
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

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs = inputs@{self, nixpkgs, home-manager, spicetify-nix, nixos-hardware, winapps, ...}:

  let
    pkgs = {
      pkgsUnstable = inputs.nixpkgs-unstable.legacyPackages.${system};
    };
    profile = "t480";
    hostname = "t480";
    system = "x86_64-linux";
    users = ["axel"];
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
        inherit self nixos-hardware winapps users hostname system nixpkgs;
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
          inputs.caelestia-shell.homeManagerModules.default
          inputs.nix-index-database.homeModules.nix-index
        ];
        extraSpecialArgs = {
          inherit profile spicetify-nix user nixpkgs;
        } // pkgs;
      };
    }) users);
  };
}
