# ./nixos/host/services/index.nix
{config, pkgs, ...}: # Standard NixOS modules

{
  imports = [
    ./virtualization.nix
    ./packs.nix
    ./vpn.nix
    ./desktop.nix
    ./dbms.nix
    ./streaming.nix
  ];
}