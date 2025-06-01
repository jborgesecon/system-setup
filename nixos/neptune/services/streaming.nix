# ./home-manager/borges/streaming.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Video
    droidcam
    # obs-studio    # already enabled
  ];

  programs = {
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        droidcam-obs
      ];
    };
  };
}