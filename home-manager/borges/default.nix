# ./home-manager/borges/default.nix
{ pkgs, inputs, config, lib, ... }:

{
  imports = [
    ./programs.nix
    ./shell.nix
    ./R.nix
    ./latex.nix
    # ./services/index.nix
  ];

  home.username = "borges";
  home.homeDirectory = "/home/borges"; # Or however your home is set

  # Enable Home Manager itself (so it can manage your files)
  programs.home-manager.enable = true;
  
  # Disable KWallet to prevent conflicts
  home.sessionVariables = {
    KDE_WALLET_DISABLED = "1";
  };
  
  # Override KWallet configuration to disable it
  home.file.".config/kwalletrc".text = ''
    [Wallet]
    Close When Idle=false
    Close on Screensaver=false
    Default Wallet=kdewallet
    Enabled=false
    First Use=false
    Idle Timeout=10
    Launch Manager=false
    Leave Manager Open=false
    Leave Open=false
    Prompt on Open=false
    Use One Wallet=true

    [org.freedesktop.secrets]
    apiEnabled=false
  '';
  
  home.stateVersion = "25.05"; # Update this too
}