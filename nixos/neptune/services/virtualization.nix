# ./nixos/neptune/services/index.nix
{config, pkgs, ...}: # Standard NixOS modules

{
    # Virtualization Services
    virtualisation = {

        # VBox Setup
        virtualbox.host.enable = true;

        # Docker Setup
        docker.rootless = {
            enable = true;
            setSocketVariable = true;
        };
    };
}