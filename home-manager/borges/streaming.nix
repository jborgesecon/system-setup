{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Video
    droidcam
    obs-studio
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