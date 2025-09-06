# ./home-manager/borges/default.nix
{ pkgs, inputs, config, lib, ... }:

{
  imports = [
    ./programs.nix
    ./shell.nix
    ./R.nix
    ./latex.nix
    # ./services/index.nix
  ];

  home.username = "borges";
  home.homeDirectory = "/home/borges"; # Or however home is set

  # Enable Home Manager itself (so it can manage files)
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}