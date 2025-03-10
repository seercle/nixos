{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{self, nixpkgs, home-manager,...}:
  
  let
    systemSettings = {
      profile = "homelab";
      hostname = "homelab";
      system = "x86_64-linux";
      timezone = "Europe/Paris";
      wolInterface = "enp4s0";
    };
    vpnSettings = {
        ips = ["10.0.0.1/24"];
        externalInterface = "enp4s0";
        port = 51820;
        privateKeyFile = "/root/vpn/wg-private";
        peers = [
          {
            publicKey = "xQaF3IfJQvmHEzytEVAG2xBSdn56NsqRXt2eIUGYJRY=";
            allowedIPs = ["10.0.0.2/32"];
          }
        ];
    };
    #the usernames must match the directories in profiles/your_profile/users/
    usernames = [
      "axel" 
      "william"
    ];
  in {
    homeConfigurations = builtins.listToAttrs (builtins.map(username: {
      name = username; 
      value = home-manager.lib.homeManagerConfiguration {          
        pkgs = nixpkgs.legacyPackages.${systemSettings.system};
        modules = [
          ./home.nix
          ./profiles/${systemSettings.profile}/home.nix
          ./profiles/${systemSettings.profile}/users/${username}/home.nix
        ];
        extraSpecialArgs = {
          inherit username;
        };
      };
    }) usernames);

    nixosConfigurations.${systemSettings.hostname} = nixpkgs.lib.nixosSystem {
      system = systemSettings.system;
      modules = [
        ./configuration.nix
        ./profiles/${systemSettings.profile}/configuration.nix
      ] ++ builtins.map (username: ./profiles/${systemSettings.profile}/users/${username}/configuration.nix) usernames;
      specialArgs = {
        inherit systemSettings;
        inherit vpnSettings;
        inherit usernames;
      };
    };
  };
}
