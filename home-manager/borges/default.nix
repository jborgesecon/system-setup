# ./home-manager/borges/default.nix
{ pkgs, inputs, config, lib, ... }:

{
  imports = [
    ./programs.nix
    ./shell.nix
    ./R.nix
    ./streaming.nix
    # ./services/index.nix
  ];

  home.username = "borges";
  home.homeDirectory = "/home/borges"; # Or however your home is set

  # Enable Home Manager itself (so it can manage your files)
  programs.home-manager.enable = true;
  home.stateVersion = "24.05"; # CRITICAL: Align with your nixpkgs/NixOS stateVersion
}