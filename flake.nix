# ./flake.nix
{
  description = "My NixOS and Home Manager configuration";

  inputs = {
    nixpkgs = {
        type = "github";
        owner = "NixOS";
        repo = "nixpkgs";
        ref = "nixos-24.11;
    };

    home-manager = {
        type = "github";
        owner = "nix-community";
        repo = "home-manager";
        ref = "release-24-05";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};

      # System-wide setup
      mkNixosConfiguration = hostname: extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs; }; 
          modules = [
            ./nixos/neptune/default.nix 
            home-manager.nixosModules.home-manager 
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs pkgs; };
            }
          ] ++ extraModules;
        };
      
      # Home-Manager setup
      mkHomeConfiguration = username: extraModules:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs pkgs; }; 
          modules = [
            ./home/borges/home.nix 
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        neptune = mkNixosConfiguration "neptune" [
            # Any extra configuration here
        ];
      };
      homeConfiguration = {
        borges = mkHomeConfiguration "borges" [
            # Some extra configuration here
        ];
      };
    };
}
