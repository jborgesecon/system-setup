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
        home-manager
        flatpak
        gnugrep
        gnused
        gcc
        gnumake42
        pkg-config
        tree
        openssh
        openssl

        neovim
        alacritty
        fish
        htop
        neofetch
        qdirstat

        python3Full
        postgresql
        docker-compose
        gretl
        R

        dbeaver-bin
        postman
        vscode
        git

        calibre
        libreoffice
        discord
        telegram-desktop
        tor
        tor-browser
        brave
        bisq2
        obs-studio

        dconf-editor
        kcalc
        ];

    fonts.packages = with pkgs; [
        nerdfonts
    ];
}