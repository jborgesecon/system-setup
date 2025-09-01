# ./home-manager/borges/streaming.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # droidcam
    android-tools
    v4l-utils
    ffmpeg-full
    scrcpy
    # obs-studio    # already enabled
  ];

  programs = {
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-multi-rtmp
      ];
    };
  };
}