# ./nixos/neptune/services/vpn.nix
{config, pkgs, ...}: # Standard NixOS modules

let
  # --- 1. Define Your VPN Aliases and Config Files ---
  locations = {
    # eg. "service-name-suffix" = "filename.ovpn"
    "surfshark-ZUR" = "ch-zur.prod.surfshark.com_udp.ovpn";
    "surfshark-US1" = "us-atl.prod.surfshark.com_udp.ovpn";
    "surfshark-US2" = "us-ash.prod.surfshark.com_udp.ovpn";
    "surfshark-BRA" = "br-sao.prod.surfshark.com_udp.ovpn";
    "surfshark-BEL" = "be-anr.prod.surfshark.com_udp.ovpn";
    "surfshark-TCP" = "is-rkv.prod.surfshark.com_tcp.ovpn";
  };

  # --- 2. Helper function to generate a server config ---
  mkServer = ovpnFile: {
    config = ''
      config /etc/openvpn/surfshark/${ovpnFile}
    '';
    autoStart = false;
    updateResolvConf = true;
  };
in
{
  services.openvpn.servers =
    # --- 3. NixOS Feature ---
    # This line automatically generates a full server entry
    # for every single item you defined in "locations" above.
    pkgs.lib.mapAttrs (name: ovpnFile: mkServer ovpnFile) locations;
}