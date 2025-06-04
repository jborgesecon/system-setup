# ./nixos/neptune/services/vpn.nix
{config, pkgs, ...}: # Standard NixOS modules

{
    services = {

        # OpenVPN Setup
        openvpn.servers = {
            surfshark = {
                config = ''
                    config /etc/openvpn/surfshark/us-ash.prod.surfshark.com_udp.ovpn
                '';
                autoStart = false;
                updateResolvConf = true;
            };
        };
    };
}
