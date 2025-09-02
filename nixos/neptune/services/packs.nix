# ./nixos/neptune/services/packs.nix
{config, pkgs, lib, ...}: # Added lib to inputs

{
    # Install Packages
    environment.systemPackages = with pkgs; [
        unzip
        ntfs3g
        exfat
        exfatprogs
        wget
        flatpak
        gnugrep
        gnused
        gcc
        git
        gnumake42
        pkg-config
        tree
        wl-clipboard
        openssh
        openssl
        home-manager
        kdePackages.kcalc
    ];

    fonts.packages = with pkgs.nerd-fonts; [
      fira-code
      jetbrains-mono
      hurmit
      hack
    ];
}