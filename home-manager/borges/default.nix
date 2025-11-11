# ./home-manager/borges/default.nix
{ pkgs, inputs, config, lib, ... }:

{
  imports = [
    ./programs.nix
    ./shell.nix
    ./python.nix
    ./R.nix
    # ./latex.nix
    # ./services/index.nix
  ];

  home.username = "borges";
  home.homeDirectory = "/home/borges"; # Or however home is set

  # Enable Home Manager itself (so it can manage files)
  programs.home-manager.enable = true;

  # Enable systemd user services for home-manager
  systemd.user.enable = true;
  
  # Service to activate home-manager on boot
  systemd.user.services.home-manager-activation = {
    Unit = {
      Description = "Home Manager environment activation";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'source ~/.profile'";
      RemainAfterExit = true;
    };
  };

  # Add home-manager profile to PATH in session variables
  home.sessionPath = [
    "$HOME/.local/state/nix/profiles/home-manager/home-path/bin"
  ];

  # Ensure environment variables are properly set
  home.sessionVariables = {
    PATH = "$HOME/.local/state/nix/profiles/home-manager/home-path/bin:$PATH";
  };

  # Note: This should remain stable for existing home configurations unless performing major upgrades
  # See .env file for version management strategy
  home.stateVersion = "24.11";
}