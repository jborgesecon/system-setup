{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    glib
    gsettings-desktop-schemas
    file
    open-sans

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
    inkscape
    blender
    kdePackages.kdenlive
    calibre
    libreoffice
    # texstudio
    geekbench
    discord
    telegram-desktop
    brave
    bisq2
    dconf-editor
    qgis

    pandoc
    ffmpeg
    gretl
    goverlay
    mangohud

    tesseract
    haruna
    qbittorrent
  ];

  programs.firefox.enable = true;
}