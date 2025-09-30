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
        };
        libinput.enable = true;
        desktopManager = {
            plasma6.enable = true;
        };
        
        # Additional KDE Plasma configuration
        pipewire = {
            enable = true;
            alsa.enable = true;
            pulse.enable = true;
        };
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

    # Ensure GSettings schemas are available system-wide
    environment.pathsToLink = [ "/share/gsettings-schemas" ];
}