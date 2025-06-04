# home-manager/borges/shell.nix
{ config, pkgs, ... }:

let
  fisherSrc = pkgs.fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "fisher";
    rev = "4.4.5";
    sha256 = "sha256-VC8LMjwIvF6oG8ZVtFQvo2mGdyAzQyluAGBoK8N2/QM="; # Temporary dummy
  };

in 
{
  home.packages = with pkgs; [
    alacritty
    fish
    oh-my-posh
    htop
    neofetch
    qdirstat
    direnv
  ];

  # Customize Alacritty:
  programs.alacritty = {
    enable = true;
    # theme = "solarized_dark";
    settings = {
      selection.save_to_clipboard = true;
      colors.selection.background = "0xffffff";
      font = {
        normal.family = "FiraCode Nerd Font Mono Ret";
  size = 12;
      };
      window = {
        opacity = 0.72;
  decorations = "buttonless";
  padding = {
    x = 8;
    y = 8;
  };
      };
      scrolling = {
        history = 2000;
  multiplier = 3;
      };
      terminal.shell = {
        program = "${pkgs.fish}/bin/fish";
        # args = [ "--command=tmux" ];
      };
    };
  };

  # Customize fish
   programs.fish = {
     enable = true;
     shellInit = ''
       set -g fish_greeting "Welcome, Human!"
     '';
     plugins = [
       { name = "fisher"; src = fisherSrc; }
#       { name = "dracula"; src = pkgs.fishPlugins.dracula; }
     ];
   };

   programs.oh-my-posh = {
     enable = true;
     useTheme = "di4am0nd";
   };

   programs.neovim = {
     enable = true;
     extraConfig = ''
       set number relativenumber
     '';
   };
}