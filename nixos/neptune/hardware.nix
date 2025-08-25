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
        options = [ "defaults" "user" ];
    };

    # Automatically set ownership for Ollie mount
    systemd.services.ollie-ownership = {
        description = "Set ownership for Ollie mount";
        after = [ "media-ollie.mount" ];
        wants = [ "media-ollie.mount" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.coreutils}/bin/chown -R 1000:100 /media/ollie";
        };
    };

    # Blueman
    services.blueman.enable = true;
    services.printing.enable = true;
}
