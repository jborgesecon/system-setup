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
  # System packages
  home.packages = with pkgs; [
    alacritty
    fish
    oh-my-posh
    htop
    neofetch
    qdirstat
    direnv
    tmux
  ];

  # Terminal emulator configuration
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
      
      # Key bindings to send Ctrl+Tab sequences to tmux
      key_bindings = [
        { key = "Tab"; mods = "Control"; chars = "\\x1b[27;5;9~"; }
        { key = "Tab"; mods = "Control|Shift"; chars = "\\x1b[27;6;9~"; }
      ];
    };
  };

  # Terminal multiplexer configuration
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "screen-256color";
    
    extraConfig = ''
      # Bind Ctrl+Tab to switch to the next window (no prefix needed)
      bind-key -n C-Tab next-window

      # Bind Ctrl+Shift+Tab to switch to the previous window (no prefix needed)
      bind-key -n C-S-Tab previous-window
    '';
  };

  # Shell configuration
  programs.fish = {
    enable = true;
    shellInit = ''
      set -g fish_greeting "Welcome, Human!"
    '';
    plugins = [
      { name = "fisher"; src = fisherSrc; }
      # { name = "dracula"; src = pkgs.fishPlugins.dracula; }
    ];
  };

  # Prompt theme configuration
  programs.oh-my-posh = {
    enable = true;
    useTheme = "di4am0nd";
  };

  # Text editor configuration
  programs.neovim = {
    enable = true;
    extraConfig = ''
      set number relativenumber
    '';
  };
}