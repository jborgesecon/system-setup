# ./nixos/neptune/default.nix
{ inputs, pkgs, neptune, ... }: # 'neptune' is available from specialArgs in flake.nix
{
  imports = [
    ./hardware.nix
    ./system.nix
    ./users.nix
    ./services/index.nix
  ];

  # Ensure your system's state version is set
  system.stateVersion = "24.11";
}
