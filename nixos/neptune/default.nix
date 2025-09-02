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
  system.stateVersion = "25.05";
}
