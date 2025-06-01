# ./nixos/neptune/services/vpn.nix
{config, pkgs, ...}: # Standard NixOS modules

{
    services = {

        # OpenVPN Setup
        openvpn.servers = {
            surfshark = {
                config = ''
                    config /etc/openvpn/surfshark/be-bru.prod.surfshark.com_udp.ovpn
                '';
                autoStart = false;
                updateResolvConf = true;
            };
        };
    };
}
