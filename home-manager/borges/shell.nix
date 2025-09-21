# Shell environment and terminal configuration
{ config, lib, pkgs, ... }:

let
  # Fisher plugin manager source
  fisherSrc = pkgs.fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "fisher";
    rev = "4.4.5";
    sha256 = "sha256-VC8LMjwIvF6oG8ZVtFQvo2mGdyAzQyluAGBoK8N2/QM=";
  };
  
  # Common shell
  defaultShell = "${pkgs.fish}/bin/fish";
in
{
  # ===== PACKAGES =====
  home.packages = with pkgs; [
    # Terminal environment
    alacritty
    fish
    tmux
    oh-my-posh
    
    # System utilities  
    htop
    neofetch
    qdirstat
    direnv
    nix-direnv
  ];

  # ===== SHELL CONFIGURATION =====
  programs.fish = {
    enable = true;
    shellInit = ''
      set -g fish_greeting "Welcome, Human!"
      oh-my-posh init fish --config ~/.config/oh-my-posh/themes/di4am0nd.omp.json | source
      
      # Export GUI-related environment variables
      set -gx GDK_BACKEND x11
      set -gx QT_QPA_PLATFORM xcb
      set -gx GTK_USE_PORTAL 1
      set -gx QT_QPA_PLATFORMTHEME kde
      set -gx GTK_THEME "Adwaita:dark"
    '';
    plugins = [
      { name = "fisher"; src = fisherSrc; }
    ];
  };

  programs.oh-my-posh = {
    enable = true;
    useTheme = "di4am0nd";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ===== TERMINAL APPLICATIONS =====
  programs.tmux = {
    enable = true;
    shell = defaultShell;
    terminal = "xterm-256color";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell.program = defaultShell;
      
      font = {
        normal.family = "FiraCode Nerd Font Mono";
        bold.family = "FiraCode Nerd Font Mono"; 
        italic.family = "FiraCode Nerd Font Mono";
        size = 12;
      };
      
      window = {
        opacity = 0.72;
        decorations = "buttonless";
        padding = { x = 10; y = 10; };
        dynamic_title = true;
      };
      
      scrolling = {
        history = 5000;
        multiplier = 3;
      };
      
      selection.save_to_clipboard = true;
      
      colors = {
        primary = {
          background = "#232526";
          foreground = "#cdd6f4";
        };
        selection = {
          background = "#585b70";
          text = "#cdd6f4";
        };
      };
    };
  };

  # ===== EDITOR CONFIGURATION =====
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      set number relativenumber
      set tabstop=2 shiftwidth=2 expandtab
      set autoindent smartindent
      syntax enable
      set incsearch hlsearch ignorecase smartcase
    '';
  };

  # ===== ENVIRONMENT VARIABLES =====
  home.sessionVariables = {
    # Core applications
    EDITOR = "nvim";
    TERMINAL = "alacritty";
    SHELL = defaultShell;

    # X11/Wayland compatibility
    GDK_BACKEND = "x11";
    QT_QPA_PLATFORM = "xcb";
    
    # Desktop integration
    GTK_USE_PORTAL = "1";
    QT_QPA_PLATFORMTHEME = "kde";
    GTK_THEME = "Adwaita:dark";
    
    # GSettings schema paths (consider using nixpkgs references instead of hardcoded paths)
    XDG_DATA_DIRS = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas:${pkgs.gtk3}/share/gsettings-schemas:\${XDG_DATA_DIRS}";
  };

  # Set systemd user environment variables for GUI applications
  systemd.user.sessionVariables = {
    GDK_BACKEND = "x11";
    QT_QPA_PLATFORM = "xcb";
    GTK_USE_PORTAL = "1";
    QT_QPA_PLATFORMTHEME = "kde";
    GTK_THEME = "Adwaita:dark";
  };

}