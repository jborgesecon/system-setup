# NixOS & Home Manager Configuration

[![NixOS](https://img.shields.io/badge/NixOS-25.05-blue.svg?style=flat&logo=nixos&logoColor=white)](https://nixos.org)
[![Home Manager](https://img.shields.io/badge/Home%20Manager-25.05-blue.svg?style=flat&logo=nixos&logoColor=white)](https://github.com/nix-community/home-manager)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A comprehensive NixOS and Home Manager configuration for the `neptune` system, featuring a complete development environment with scientific computing, multimedia, and productivity tools.

## 📖 Table of Contents

- [Overview](#overview)
- [System Architecture](#system-architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration Structure](#configuration-structure)
- [Usage](#usage)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This repository contains a modular NixOS and Home Manager configuration designed for development, scientific computing, and multimedia work. The setup is organized around:

- **Host**: `neptune` - Main development workstation
- **User**: `borges` - Primary user configuration
- **Desktop**: KDE Plasma 6 with Wayland
- **Python**: Comprehensive scientific computing stack
- **Development**: Modern development tools and environments

## 🏗️ System Architecture

```
flakes/
├── flake.nix                      # Main flake configuration
├── flake.lock                     # Version lock file
├── home-manager/
│   └── borges/                    # User-specific configurations
│       ├── default.nix            # Main home configuration
│       ├── programs.nix           # Application packages
│       ├── python.nix             # Python environment
│       ├── R.nix                  # R statistical environment
│       ├── shell.nix              # Shell configuration
│       ├── latex.nix              # LaTeX setup (optional)
│       └── services/              # User services
├── nixos/
│   └── neptune/                   # Host-specific configurations
│       ├── default.nix            # Main system configuration
│       ├── hardware.nix           # Hardware-specific settings
│       ├── system.nix             # System-wide settings
│       ├── users.nix              # User account management
│       └── services/              # System services
│           ├── index.nix          # Service imports
│           ├── desktop.nix        # KDE Plasma setup
│           ├── virtualization.nix # Docker/VM support
│           ├── dbms.nix           # Database services
│           ├── streaming.nix      # Media streaming
│           ├── vpn.nix            # VPN configuration
│           └── packs.nix          # Package collections
└── templates/                     # Utility templates
    ├── direnv_setup.bash
    ├── shell.nix
    └── sys_cleanup.sh
```

## ✨ Features

### 🖥️ Desktop Environment
- **KDE Plasma 6** with Wayland support
- **SDDM** display manager
- **PipeWire** audio system
- Brazilian Portuguese keyboard layout
- Intel graphics drivers

### 🐍 Python Development
- **Python 3.12** with comprehensive package collection
- **Scientific Computing**: NumPy, SciPy, Pandas, Matplotlib, Seaborn
- **Machine Learning**: TensorFlow, PyTorch, Scikit-learn, LightGBM
- **Jupyter Environment**: JupyterLab, Notebook, IPython
- **Web Development**: FastAPI, Flask, Django, Streamlit
- **Development Tools**: Black, Flake8, MyPy, Pytest

### 📊 Scientific & Data Analysis
- **R Environment** with statistical packages
- **GRETL** for econometrics
- **QGIS** for GIS analysis
- **Database Tools**: DBeaver, PostgreSQL

### 🛠️ Development Tools
- **IDEs**: VSCode, Android Studio
- **Containerization**: Docker with Docker Compose
- **Version Control**: Git (configured via Home Manager)
- **API Testing**: Postman
- **Text Processing**: Pandoc, Tesseract OCR

### 🎨 Creative & Multimedia
- **Graphics**: GIMP, Inkscape, Blender
- **Video**: Kdenlive, FFmpeg, Haruna player
- **Office**: LibreOffice suite
- **E-books**: Calibre

### 🌐 Web & Communication
- **Browsers**: Firefox, Brave, Tor Browser
- **Communication**: Discord, Telegram
- **Privacy**: Tor, VPN support

### 🎮 Gaming & Entertainment
- **Performance Monitoring**: MangoHud, GOverlay
- **Media**: yt-dlp for video downloads
- **P2P**: qBittorrent

### 💰 Finance
- **Trading**: Bisq2 decentralized exchange

## 📋 Prerequisites

- **Hardware**: x86_64 system with UEFI boot
- **Storage**: At least 20GB free space
- **Internet**: Stable connection for package downloads
- **Knowledge**: Basic understanding of Nix/NixOS concepts

## 🚀 Installation

### Fresh NixOS Installation

1. **Boot from NixOS installer** and complete basic system setup
2. **Clone this repository**:
   ```bash
   git clone https://github.com/jborgesecon/system-setup.git /etc/nixos/flakes
   cd /etc/nixos/flakes
   ```

3. **Update hardware configuration**:
   ```bash
   # Generate hardware config for your system
   nixos-generate-config --show-hardware-config > nixos/neptune/hardware-configuration.nix
   ```

4. **Apply NixOS configuration**:
   ```bash
   sudo nixos-rebuild switch --flake .#neptune
   ```

5. **Apply Home Manager configuration**:
   ```bash
   nix run home-manager/release-25.05 -- switch --flake .#borges
   ```

### Updating Existing System

1. **Navigate to configuration directory**:
   ```bash
   cd /home/borges/.config/flakes
   ```

2. **Update flake inputs**:
   ```bash
   nix flake update
   ```

3. **Rebuild system**:
   ```bash
   sudo nixos-rebuild switch --flake .#neptune
   ```

4. **Update Home Manager**:
   ```bash
   home-manager switch --flake .#borges
   ```

## 📁 Configuration Structure

### System Configuration (`nixos/neptune/`)

- **`default.nix`**: Main system imports and state version
- **`hardware.nix`**: Hardware-specific configurations
- **`system.nix`**: Boot, networking, locale, and system settings
- **`users.nix`**: User account definitions
- **`services/`**: Modular service configurations

### Home Configuration (`home-manager/borges/`)

- **`default.nix`**: Main home imports and user settings
- **`programs.nix`**: Application packages and program configs
- **`python.nix`**: Python environment with scientific packages
- **`R.nix`**: R statistical computing environment
- **`shell.nix`**: Shell and terminal configurations

### Services Architecture

**System Services** (`nixos/neptune/services/`):
- **Desktop**: KDE Plasma, display management, audio
- **Virtualization**: Docker, VMs, containers
- **DBMS**: Database services and tools
- **VPN**: Network privacy and security
- **Streaming**: Media server capabilities

## 💡 Usage

### Daily Operations

**System Updates**:
```bash
# Update all packages
sudo nixos-rebuild switch --flake .#neptune --upgrade

# Update only Home Manager
home-manager switch --flake .#borges
```

**Package Management**:
```bash
# Search for packages
nix search nixpkgs python312Packages.numpy

# Test packages temporarily
nix shell nixpkgs#packagename

# Add packages by editing configuration files
```

**Development Environments**:
```bash
# Enter Python development shell
nix develop

# Use project-specific shells
nix-shell templates/shell.nix
```

### Python Environment

The Python environment includes pre-configured packages for:
- **Data Science**: pandas, numpy, scipy, matplotlib
- **Machine Learning**: tensorflow, pytorch, scikit-learn
- **Web Development**: fastapi, django, streamlit
- **Jupyter**: jupyterlab, notebook, ipython

Access Jupyter:
```bash
jupyter lab
# or
jupyter notebook
```

### Database Development

PostgreSQL and DBeaver are pre-configured:
```bash
# Start PostgreSQL (if configured as service)
systemctl start postgresql

# Connect with DBeaver (GUI)
dbeaver
```

## 🎨 Customization

### Adding New Packages

**System packages** (`nixos/neptune/`):
```nix
# In appropriate service file
environment.systemPackages = with pkgs; [
  your-new-package
];
```

**User packages** (`home-manager/borges/programs.nix`):
```nix
home.packages = with pkgs; [
  your-new-package
];
```

**Python packages** (`home-manager/borges/python.nix`):
```nix
# Add to appropriate category
utilityPackages = with pkgs.python312Packages; [
  existing-package
  your-new-python-package
];
```

### Creating New Configurations

1. **New host**: Copy `nixos/neptune/` to `nixos/new-host/`
2. **New user**: Copy `home-manager/borges/` to `home-manager/new-user/`
3. **Update `flake.nix`** with new configurations

### Environment Customization

**Shell configuration** (`home-manager/borges/shell.nix`):
- Customize shell aliases, functions, and environment variables

**Desktop settings**: 
- KDE Plasma settings are managed through the GUI
- Additional desktop configuration can be added to `services/desktop.nix`

## 🔧 Troubleshooting

### Common Issues

**Build Failures**:
```bash
# Clean build cache
nix-collect-garbage -d

# Rebuild with verbose output
nixos-rebuild switch --flake .#neptune --show-trace
```

**Home Manager Conflicts**:
```bash
# Remove existing conflicting files
rm ~/.config/conflicting-file

# Force Home Manager rebuild
home-manager switch --flake .#borges -b backup
```

**Package Not Found**:
```bash
# Update flake inputs
nix flake update

# Search for correct package name
nix search nixpkgs package-name
```

**Python Package Issues**:
- Check if package is available in nixpkgs
- Consider using `python312.withPackages` for complex dependencies
- Use poetry2nix for Poetry projects

### System Recovery

**Rollback System**:
```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback
```

**Rollback Home Manager**:
```bash
# List home generations
home-manager generations

# Rollback
home-manager switch --flake .#borges --rollback
```

### Debugging

**Verbose rebuild**:
```bash
nixos-rebuild switch --flake .#neptune --show-trace --verbose
```

**Check service status**:
```bash
systemctl status service-name
journalctl -u service-name
```

## 🤝 Contributing

### Development Workflow

1. **Fork** the repository
2. **Create feature branch**: `git checkout -b feature/your-feature`
3. **Test changes** on your system
4. **Commit changes**: `git commit -am 'Add your feature'`
5. **Push branch**: `git push origin feature/your-feature`
6. **Create Pull Request**

### Code Style

- **Nix formatting**: Use `nixpkgs-fmt` for consistent formatting
- **Comments**: Document complex configurations
- **Modularity**: Keep configurations modular and reusable
- **Testing**: Test configurations before submitting

### Adding New Features

1. **System services**: Add to `nixos/neptune/services/`
2. **User programs**: Add to `home-manager/borges/`
3. **Documentation**: Update README and add inline comments
4. **Templates**: Add useful templates to `templates/`

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/packages)
- [NixOS Wiki](https://nixos.wiki/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)

## 📄 License

This configuration is released under the [MIT License](LICENSE). Feel free to use, modify, and distribute as needed.

## 🙏 Acknowledgments

- [NixOS Community](https://nixos.org/community.html) for the amazing ecosystem
- [Home Manager](https://github.com/nix-community/home-manager) contributors
- All package maintainers in the nixpkgs repository

---

**Maintained by**: [@jborgesecon](https://github.com/jborgesecon)  
**Last Updated**: September 2025  
**NixOS Version**: 25.05  
**Home Manager Version**: 25.05