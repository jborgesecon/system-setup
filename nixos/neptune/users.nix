{ config, pkgs, neptune, lib, ... }:

{
    # User Account
    users = {
        users = {
            borges = {
                isNormalUser = true;
                description = "borges";
                shell = pkgs.bash;
                extraGroups = [ "networkmanager" "wheel" "docker"];
            };
            guest = {
                isNormalUser = true;
                description = "Guest User";
                shell = pkgs.bash;
                extraGroups = [ "networkmanager"];
                packages = with pkgs; [
                    firefox
                    konsole
                ];
                initialPassword = "";
            };
        };
        extraGroups.vboxusers.members = [ "borges"];
    };
}