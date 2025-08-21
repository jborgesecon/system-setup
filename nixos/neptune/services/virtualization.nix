# ./nixos/neptune/services/index.nix
{config, pkgs, ...}: # Standard NixOS modules

{
    # Virtualization Services
    virtualisation = {

        # VBox Setup
        virtualbox.host.enable = true;

        # Docker Setup
        docker = {
            # Consider disabling the system wide Docker daemon
            enable = false;

            rootless = {
                enable = true;
                setSocketVariable = true;
                # Optionally customize rootless Docker daemon settings
                daemon.settings = {
                    dns = [ "1.1.1.1" "8.8.8.8" ];
                    registry-mirrors = [ "https://mirror.gcr.io" ];
                };
            };
        };
    };
}