# ./nixos/neptune/services/packs.nix
{config, pkgs, lib, ...}: # Added lib to inputs

{
    # Install Packages
    environment.systemPackages = with pkgs; [
        unzip
        ntfs3g
        exfat
        exfatprogs
        parted
        wget
        flatpak
        gnugrep
        gnuplot
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
        
        # GSettings support for all applications
        glib
        glib.dev  # Includes glib-compile-schemas and other dev tools
        gsettings-desktop-schemas
        gtk3
        
        # Scientific computing dependencies (from shell.nix)
        zlib          # Compression library (e.g., for pandas, Pillow)
        libffi        # Foreign Function Interface library
        zeromq        # Messaging library (for jupyter, pyzmq)
        gfortran      # Fortran compiler (for scipy, numpy)
        sqlite        # SQLite database library
        libxml2       # XML parsing library
        libxslt       # XSLT transformation library
        freetype      # Font rendering (for matplotlib)
        cairo         # 2D graphics library
        
        # Additional C++ development tools
        stdenv.cc.cc.lib  # C++ standard library
        cmake         # Build system generator
        gnumake       # Make build tool
    ];

    fonts.packages = with pkgs.nerd-fonts; [
      fira-code
      jetbrains-mono
      hurmit
      hack
    ];
}