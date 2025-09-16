# ./home-manager/borges/default.nix
{ pkgs, inputs, config, lib, ... }:

{
  imports = [
    ./programs.nix
    ./shell.nix
    ./python.nix
    ./R.nix
    # ./latex.nix
    # ./services/index.nix
  ];

  home.username = "borges";
  home.homeDirectory = "/home/borges"; # Or however home is set

  # Enable Home Manager itself (so it can manage files)
  programs.home-manager.enable = true;

  # Note: This should remain stable for existing home configurations unless performing major upgrades
  # See .env file for version management strategy
  home.stateVersion = "24.11";
}