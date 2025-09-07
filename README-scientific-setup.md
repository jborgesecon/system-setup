# System Configuration - Scientific Computing Setup

## Overview
This NixOS configuration has been updated to support scientific computing with system-wide dependencies and uses the nixos-unstable channel for latest packages.

## Version Management Strategy

### .env Configuration
- **NIXPKGS_CHANNEL**: `nixos-unstable` - Latest packages for scientific computing
- **HOME_MANAGER_CHANNEL**: `master` - Latest home-manager features
- **SYSTEM_STATE_VERSION**: `25.05` - Remains stable for existing systems
- **HOME_STATE_VERSION**: `25.05` - Remains stable for existing home configurations

### Why State Versions Remain at 25.05
The `stateVersion` should **NOT** be changed on existing systems unless performing a major upgrade. This value tells NixOS/Home Manager what defaults were used when the system was first installed, ensuring compatibility with existing data and configurations.

## Scientific Computing Dependencies

The following packages are now installed system-wide in `/nixos/neptune/services/packs.nix`:

### Core Development Tools
- `gcc` - GNU Compiler Collection
- `cmake` - Build system generator  
- `gnumake` - Make build tool
- `pkg-config` - Build configuration tool
- `stdenv.cc.cc.lib` - C++ standard library

### Scientific Libraries
- `zlib` - Compression library (pandas, Pillow)
- `libffi` - Foreign Function Interface library
- `zeromq` - Messaging library (jupyter, pyzmq)
- `gfortran` - Fortran compiler (scipy, numpy)
- `sqlite` - SQLite database library
- `libxml2` - XML parsing library
- `libxslt` - XSLT transformation library
- `freetype` - Font rendering (matplotlib)
- `cairo` - 2D graphics library

### Environment Variables
System-wide environment variables are configured in `/nixos/neptune/system.nix`:
- `LD_LIBRARY_PATH` - Includes C++ standard library path
- `PKG_CONFIG_PATH` - For build configuration

## Migration from shell.nix
The dependencies previously defined in your personal `shell.nix` are now available system-wide, ensuring:
- Consistent environment across all users
- Better integration with NixOS package management
- Reduced duplication between development environments

## Usage
1. After making changes, rebuild the system:
   ```bash
   sudo nixos-rebuild switch --flake .#neptune
   ```

2. Update home-manager configuration:
   ```bash
   home-manager switch --flake .#borges
   ```

3. Update flake inputs to get latest packages:
   ```bash
   nix flake update
   ```

## File Structure Changes
- `/flake.nix` - Updated to use unstable channels
- `/nixos/neptune/services/packs.nix` - Added scientific computing packages
- `/nixos/neptune/system.nix` - Added environment variables
- `/.env` - Version management configuration
- `/.gitignore` - Added .env to ignore list
