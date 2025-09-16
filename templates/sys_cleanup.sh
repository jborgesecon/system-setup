#!/usr/bin/env bash

# NixOS and Home Manager System Cleanup Script
# This script performs a comprehensive cleanup of old generations, unused packages,
# and various caches to free up disk space and maintain a clean system.

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to get disk usage before and after
get_disk_usage() {
    df -h / | awk 'NR==2 {print $3}'
}

# Function to get nix store size
get_nix_store_size() {
    du -sh /nix/store 2>/dev/null | cut -f1 || echo "Unknown"
}

# Check if running as root for system operations
check_root() {
    if [[ $EUID -ne 0 ]] && [[ "$1" == "system" ]]; then
        print_error "System cleanup requires root privileges. Please run with sudo."
        exit 1
    fi
}

# Function to cleanup old NixOS generations
cleanup_nixos_generations() {
    print_status "Cleaning up old NixOS generations..."
    
    # Show current generations
    print_status "Current NixOS generations:"
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
    
    # Keep only the last 3 generations (adjust as needed)
    print_status "Removing NixOS generations older than 3 generations..."
    sudo nix-collect-garbage --delete-older-than 3d
    
    # Alternative: Keep specific number of generations
    # sudo nix-env --delete-generations +3 --profile /nix/var/nix/profiles/system
    
    print_success "NixOS generations cleanup completed"
}

# Function to cleanup old Home Manager generations
cleanup_home_manager_generations() {
    print_status "Cleaning up old Home Manager generations..."
    
    # Show current generations
    print_status "Current Home Manager generations:"
    home-manager generations 2>/dev/null || nix-env --list-generations --profile ~/.local/state/nix/profiles/home-manager
    
    # Remove old Home Manager generations
    print_status "Removing Home Manager generations older than 7 days..."
    home-manager expire-generations "-7 days" 2>/dev/null || {
        print_warning "home-manager expire-generations not available, using nix-collect-garbage"
        nix-collect-garbage --delete-older-than 7d
    }
    
    print_success "Home Manager generations cleanup completed"
}

# Function to cleanup Nix store
cleanup_nix_store() {
    print_status "Cleaning up Nix store..."
    
    print_status "Running garbage collection to remove unreferenced packages..."
    nix-collect-garbage
    
    print_status "Running store optimization to deduplicate files..."
    nix-store --optimise
    
    print_success "Nix store cleanup completed"
}

# Function to cleanup various caches
cleanup_caches() {
    print_status "Cleaning up various caches..."
    
    # Clean Nix build cache
    if [[ -d ~/.cache/nix ]]; then
        print_status "Cleaning Nix cache..."
        rm -rf ~/.cache/nix/*
    fi
    
    # Clean fontconfig cache
    if [[ -d ~/.cache/fontconfig ]]; then
        print_status "Cleaning fontconfig cache..."
        rm -rf ~/.cache/fontconfig/*
    fi
    
    # Clean thumbnails
    if [[ -d ~/.cache/thumbnails ]]; then
        print_status "Cleaning thumbnail cache..."
        rm -rf ~/.cache/thumbnails/*
    fi
    
    # Clean bash history duplicates (optional)
    if [[ -f ~/.bash_history ]]; then
        print_status "Removing duplicate bash history entries..."
        sort ~/.bash_history | uniq > ~/.bash_history.tmp && mv ~/.bash_history.tmp ~/.bash_history
    fi
    
    # Clean zsh history duplicates (optional)
    if [[ -f ~/.zsh_history ]]; then
        print_status "Removing duplicate zsh history entries..."
        sort ~/.zsh_history | uniq > ~/.zsh_history.tmp && mv ~/.zsh_history.tmp ~/.zsh_history
    fi
    
    # Clean old logs
    if [[ -d ~/.local/share/nix/logs ]]; then
        print_status "Cleaning old Nix logs..."
        find ~/.local/share/nix/logs -type f -mtime +30 -delete 2>/dev/null || true
    fi
    
    print_success "Cache cleanup completed"
}

# Function to cleanup temporary files
cleanup_temp_files() {
    print_status "Cleaning up temporary files..."
    
    # Clean /tmp (be careful with this)
    print_status "Cleaning old files in /tmp (older than 7 days)..."
    sudo find /tmp -type f -atime +7 -delete 2>/dev/null || true
    
    # Clean user temp directories
    if [[ -d ~/tmp ]]; then
        print_status "Cleaning ~/tmp..."
        rm -rf ~/tmp/*
    fi
    
    # Clean Downloads folder of old files (optional - be careful)
    if [[ -d ~/Downloads ]]; then
        print_status "Listing old files in Downloads (older than 30 days)..."
        find ~/Downloads -type f -mtime +30 -ls 2>/dev/null || true
        print_warning "To delete old Downloads files, uncomment the line in the script"
        # Uncomment the next line if you want to auto-delete old downloads
        # find ~/Downloads -type f -mtime +30 -delete 2>/dev/null || true
    fi
    
    print_success "Temporary files cleanup completed"
}

# Function to cleanup broken symlinks
cleanup_broken_symlinks() {
    print_status "Cleaning up broken symlinks in home directory..."
    
    find ~ -maxdepth 3 -type l -exec test ! -e {} \; -print 2>/dev/null | while read -r symlink; do
        print_warning "Found broken symlink: $symlink"
        # Uncomment to auto-remove broken symlinks
        # rm "$symlink"
    done
    
    print_success "Broken symlinks check completed"
}

# Function to cleanup old kernels (NixOS specific)
cleanup_old_kernels() {
    print_status "Checking for old kernels..."
    
    # List current kernels
    ls -la /nix/store/*linux* 2>/dev/null | head -10 || print_status "No old kernels found in obvious locations"
    
    print_status "Old kernels will be removed by nix-collect-garbage"
}

# Function to show disk usage summary
show_disk_summary() {
    print_status "=== DISK USAGE SUMMARY ==="
    echo "Root filesystem usage: $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"
    echo "Nix store size: $(get_nix_store_size)"
    echo "Available space: $(df -h / | awk 'NR==2 {print $4}')"
    
    if command -v ncdu >/dev/null 2>&1; then
        print_status "Run 'ncdu /nix/store' for detailed Nix store analysis"
    else
        print_status "Install 'ncdu' for detailed disk usage analysis: nix-shell -p ncdu"
    fi
}

# Main cleanup function
main() {
    print_status "=== NixOS & Home Manager System Cleanup ==="
    print_status "Starting cleanup process..."
    
    # Record initial disk usage
    initial_usage=$(get_disk_usage)
    initial_store_size=$(get_nix_store_size)
    
    print_status "Initial disk usage: $initial_usage"
    print_status "Initial Nix store size: $initial_store_size"
    echo
    
    # Parse command line arguments
    CLEANUP_TYPE="user"
    KEEP_GENERATIONS=3
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --system)
                CLEANUP_TYPE="system"
                shift
                ;;
            --keep-generations)
                KEEP_GENERATIONS="$2"
                shift 2
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  --system              Perform system-wide cleanup (requires sudo)"
                echo "  --keep-generations N  Keep N generations (default: 3)"
                echo "  --help               Show this help message"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Perform cleanup based on type
    if [[ "$CLEANUP_TYPE" == "system" ]]; then
        check_root system
        cleanup_nixos_generations
    fi
    
    # User-level cleanups (can be run without root)
    cleanup_home_manager_generations
    cleanup_nix_store
    cleanup_caches
    cleanup_temp_files
    cleanup_broken_symlinks
    
    if [[ "$CLEANUP_TYPE" == "system" ]]; then
        cleanup_old_kernels
    fi
    
    # Show final summary
    echo
    final_usage=$(get_disk_usage)
    final_store_size=$(get_nix_store_size)
    
    print_success "=== CLEANUP COMPLETED ==="
    print_success "Initial disk usage: $initial_usage"
    print_success "Final disk usage: $final_usage"
    print_success "Initial Nix store size: $initial_store_size"
    print_success "Final Nix store size: $final_store_size"
    
    show_disk_summary
    
    print_success "System cleanup completed successfully!"
    print_status "Reboot recommended after major cleanups to ensure all changes take effect."
}

# Run main function with all arguments
main "$@"