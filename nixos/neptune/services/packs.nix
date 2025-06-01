# ./nixos/neptune/services/packs.nix
{config, pkgs, ...}: # Standard NixOS modules

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
        openssh
        openssl
        home-manager
        kdePackages.kcalc
        ];

    fonts.packages = with pkgs.nerd-fonts; [
        fira-code
        jetbrains-mono
        hack
    ];

}