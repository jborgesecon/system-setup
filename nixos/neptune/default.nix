# ./nixos/neptune/default.nix
{ inputs, pkgs, neptune, ... }: # 'neptune' is available from specialArgs in flake.nix
{
  imports = [
    ./hardware.nix
    ./system.nix
    ./users.nix
    ./services/index.nix
  ];

  # Update to match your target version
  # Note: This should remain stable for existing systems unless performing major upgrades
  # See .env file for version management strategy
  system.stateVersion = "24.11";
}
