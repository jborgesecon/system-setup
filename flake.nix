# ./flake.nix
{
  description = "My NixOS and Home Manager configuration";

  inputs = {
    nixpkgs = {
        type = "github";
        owner = "NixOS";
        repo = "nixpkgs";
        ref = "nixos-25.05";  # ← UPDATE THIS LINE
    };

    home-manager = {
        type = "github";
        owner = "nix-community";
        repo = "home-manager";
        ref = "release-25.05";  # ← UPDATE THIS LINE
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;

      # System-wide setup
      mkNixosConfiguration = hostname: extraModules:
        lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # Configure nixpkgs to allow unfree packages
            {
              nixpkgs.config.allowUnfree = true;
            }

            ./nixos/neptune/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.borges = import ./home-manager/borges/default.nix;
            }
          ] ++ extraModules;
        };

      mkHomeConfiguration = username: extraModules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home-manager/borges/default.nix
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        neptune = mkNixosConfiguration "neptune" [
            # Any extra configuration here
        ];
      };
      homeConfigurations = {
        borges = mkHomeConfiguration "borges" [
            # Some extra configuration here
        ];
      };
    };
}