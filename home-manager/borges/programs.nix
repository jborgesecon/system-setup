{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    glib
    gsettings-desktop-schemas
    file
    open-sans

    python3Full
    nodePackages.nodejs
    postgresql
    docker-compose
    dbeaver-bin
    postman
    vscode
    android-studio
    tor
    tor-browser

    gimp
    blender
    kdePackages.kdenlive
    calibre
    libreoffice
    texstudio
    geekbench
    discord
    telegram-desktop
    brave
    bisq2
    dconf-editor
    qgis

    pandoc
    ffmpeg
  ];

  programs.firefox.enable = true;
}