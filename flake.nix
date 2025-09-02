# ./flake.nix
{
  description = "My NixOS and Home Manager configuration";

  inputs = {
    nixpkgs = {
        type = "github";
        owner = "NixOS";
        repo = "nixpkgs";
        ref = "nixos-25.05";
    };

    home-manager = {
        type = "github";
        owner = "nix-community";
        repo = "home-manager";
        ref = "release-25.05";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # nixpkgs.config.allowUnfree = true;
  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      # Import pkgs with unfree packages allowed
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Explicitly extract lib
      lib = nixpkgs.lib;

      # System-wide setup
      mkNixosConfiguration = hostname: extraModules:
        lib.nixosSystem {
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

      mkHomeConfiguration = username: extraModules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = { inherit inputs pkgs; };
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
