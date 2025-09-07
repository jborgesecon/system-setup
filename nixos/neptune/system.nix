# ./nixos/neptune/system.nix
{ config, pkgs, neptune, lib, ... }: # 'neptune' is available

{
    # Bootloader
    boot = {
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
        supportedFilesystems = [ "ntfs" "ext4"];
    };

    # Network
    networking = {
        #proxy = {
        #    default = "http://user:password@proxy:port/";
        #    noProxy = "127.0.0.1,localhost,internal.domain";
        #};
        networkmanager.enable = true;
        firewall.enable = true;
    };

    # System Defauls
    time.timeZone = "America/Sao_Paulo";
    i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
            LC_ADDRESS = "pt_BR.UTF-8";
            LC_IDENTIFICATION = "pt_BR.UTF-8";
            LC_MEASUREMENT = "pt_BR.UTF-8";
            LC_MONETARY = "pt_BR.UTF-8";
            LC_NAME = "pt_BR.UTF-8";
            LC_NUMERIC = "pt_BR.UTF-8";
            LC_PAPER = "pt_BR.UTF-8";
            LC_TELEPHONE = "pt_BR.UTF-8";
            LC_TIME = "pt_BR.UTF-8";
        };
    };

    # Programs
    programs = {
        xwayland.enable = true;
        dconf.enable = true;
    };

    # Enable Flatpak
    services.flatpak.enable = true;

    # Environment variables for scientific computing
    environment.variables = {
        LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
        PKG_CONFIG_PATH = "${pkgs.pkg-config}/lib/pkgconfig:$PKG_CONFIG_PATH";
    };

    # Enable Flakes
    nix = {
        settings = {
            experimental-features = ["nix-command" "flakes"];
        };
    };
}