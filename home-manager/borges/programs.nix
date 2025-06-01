{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    glib
    gsettings-desktop-schemas
    gimp
    inkscape-with-extensions
    file

    python3Full
    postgresql
    docker-compose
    dbeaver-bin
    postman
    vscode
    tor
    tor-browser

    calibre
    libreoffice
    discord
    telegram-desktop
    brave
    bisq2
    dconf-editor
  ];

  programs.firefox.enable = true;
}