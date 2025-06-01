{ config, pkgs, neptune, lib, ... }:
{
    # User Account
    users = {
        users.borges = {
        isNormalUser = true;
        description = "borges";
        shell = pkgs.bash;
        extraGroups = [ "networkmanager" "wheel" "docker"];
        };
        extraGroups.vboxusers.members = [ "borges"];
    };
}