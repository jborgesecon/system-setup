{ config, pkgs, ... }:

{
home.packages = with pkgs; [
  # Core System & Utilities
  dconf-editor                          # Configuration editor for dconf
  file                                  # Utility to determine file type
  geekbench                             # System benchmark tool
  glib                                  # Core application building blocks
  gsettings-desktop-schemas             # Collection of GSettings schemas
  tesseract                             # OCR engine
  smartmontools                         # Tools for monitoring the health of hard drives
  f3
  # ventoy-full                                # New Bootable USB Solution

  # Fonts
  open-sans

  # Development
  android-studio
  dbeaver-bin
  docker-compose
  nodePackages.nodejs
  postgresql
  postman
  vscode

  # Graphics & Design
  blender
  gimp
  inkscape

  # Multimedia
  ffmpeg
  haruna
  kdePackages.kdenlive
  yt-dlp

  # Office & Productivity
  calibre                                 # E-book manager
  libreoffice                             # Open Office apps
  pandoc                                  # Universal document converter
  # texstudio                             # LaTeX editor

  # Scientific & GIS
  gretl                                   # Gnu Regression, Econometrics and Time-series Library
  qgis                                    # Geographic Information System

  # Web Browsers & Communication
  brave
  discord
  telegram-desktop
  tor-browser

  # Networking & Privacy
  qbittorrent
  tor

  # Gaming
  goverlay                                # Overlay for Vulkan and OpenGL applications
  mangohud                                # A Vulkan and OpenGL overlay for monitoring FPS, temperatures, CPU/GPU load

  # Finance
  bisq2                                   # Decentralized Bitcoin exchange

];

  programs.firefox.enable = true;
}