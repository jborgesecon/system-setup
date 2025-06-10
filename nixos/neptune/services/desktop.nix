# ./nixos/neptune/services/desktop.nix
{config, pkgs, ...}: # Standard NixOS modules

{
    services = {
        # Plasma Setup
        xserver = {
            enable = true;
            videoDrivers = ["intel"];
            xkb.layout = "br";              # Keyboard layout
            xkb.variant = "nodeadkeys";     # Keyboard variant
            desktopManager = {
                gnome.enable = false;
            };
        };
        libinput.enable = true;
        desktopManager.plasma6.enable = true;
        displayManager = {
            # autoLogin = {
            #     enable = true;
            #     user = "guest";
            # };
            sddm = {
                enable = true;
                settings = {
                    General = {
                        DefaultSession = "plasmawayland";
                    };
                };
            };
        };
    };
}