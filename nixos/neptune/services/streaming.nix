# ./home-manager/borges/streaming.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    android-tools
    v4l-utils
    ffmpeg-full
    scrcpy
  ];

  programs = {
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-multi-rtmp
        obs-advanced-masks  # Should work now!
      ];
    };
  };
}