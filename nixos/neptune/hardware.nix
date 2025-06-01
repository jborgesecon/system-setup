# ./nixos/neptune/hardware.nix
{config, pkgs, ...}: # Standard NixOS modules

{
    imports = [
        ./hardware-configuration.nix
    ];

    # Hardware
    console.keyMap = "br-abnt2";
    hardware = {
        bluetooth = {
            enable = true;
            powerOnBoot = true;
        };
    };
    security.rtkit.enable = true;

    # Mount Ollie
    fileSystems."/media/ollie" = {
        device = "/dev/sda2";
        fsType = "ext4";
    };

    # Blueman
    services.blueman.enable = true;
    services.printing.enable = true;
}