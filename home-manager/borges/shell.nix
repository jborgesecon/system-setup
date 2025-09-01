# home-manager/borges/shell.nix
{ config, pkgs, ... }:

let
  fisherSrc = pkgs.fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "fisher";
    rev = "4.4.5";
    sha256 = "sha256-VC8LMjwIvF6oG8ZVtFQvo2mGdyAzQyluAGBoK8N2/QM=";
  };
in
{
  # Essential packages
  home.packages = with pkgs; [
    # Terminal tools
    alacritty
    fish
    tmux
    
    # Prompt and themes
    oh-my-posh
    
    # System utilities
    htop
    neofetch
    qdirstat
    direnv
  ];

  # Fish shell configuration
  programs.fish = {
    enable = true;
    shellInit = ''
      # Set custom greeting
      set -g fish_greeting "Welcome, Human!"
      
      # Initialize oh-my-posh
      oh-my-posh init fish --config ~/.config/oh-my-posh/themes/di4am0nd.omp.json | source
    '';
    
    # Fisher plugin manager
    plugins = [
      { name = "fisher"; src = fisherSrc; }
    ];
  };

  # Oh-my-posh prompt configuration
  programs.oh-my-posh = {
    enable = true;
    useTheme = "di4am0nd";
  };

  # Tmux terminal multiplexer configuration
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "xterm-256color";
  };

  # Alacritty terminal emulator configuration
  programs.alacritty = {
    enable = true;
    settings = {
      # Shell configuration
      terminal.shell = {
        program = "${pkgs.fish}/bin/fish";
      };
      
      # Font configuration
      font = {
        normal = {
          family = "FiraCode Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "FiraCode Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "FiraCode Nerd Font Mono";
          style = "Italic";
        };
        size = 12;
      };
      
      # Window configuration
      window = {
        opacity = 0.72;
        decorations = "buttonless";
        padding = {
          x = 10;
          y = 10;
        };
        dynamic_title = true;
      };
      
      # Scrolling configuration
      scrolling = {
        history = 5000;
        multiplier = 3;
      };
      
      # Selection configuration
      selection = {
        save_to_clipboard = true;
      };
      
      # Color scheme (optional - you can customize)
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

  # Neovim text editor configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      " Basic settings
      set number relativenumber
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set autoindent
      set smartindent
      
      " Enable syntax highlighting
      syntax enable
      
      " Better search
      set incsearch
      set hlsearch
      set ignorecase
      set smartcase
    '';
  };

  # Directory environment setup
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "alacritty";
    SHELL = "${pkgs.fish}/bin/fish";
  };
}