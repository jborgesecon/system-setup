{ pkgs ? import <nixpkgs> { 
    config.allowUnfree = true;
    config.allowInsecure = true;
    config.permittedInsecurePackages = [
      "ventoy-1.1.05"
    ];
  }
}:

pkgs.mkShell {
  name = "ventoy-shell";
  
  buildInputs = with pkgs; [
    ventoy-full
    # Additional tools that might be useful with Ventoy
    dosfstools      # FAT filesystem utilities
    exfat           # exFAT filesystem support
    ntfs3g          # NTFS filesystem support
    parted          # Partition management
    util-linux      # Disk utilities (lsblk, fdisk, etc.)
  ];
  
  shellHook = ''
    echo "🔓 Ventoy Shell Environment"
    echo "=========================================="
    echo "Ventoy is now available in this isolated shell."
    echo ""
    echo "⚠️  SECURITY NOTICE:"
    echo "Ventoy is marked as insecure in nixpkgs."
    echo "This shell isolates it from your main system."
    echo ""
    echo "Available commands:"
    echo "  ventoy        - Main Ventoy command"
    echo "  lsblk         - List block devices"
    echo "  fdisk -l      - List disk partitions"
    echo ""
    echo "Usage example:"
    echo "  sudo ventoy -i /dev/sdX  # Install Ventoy to USB device"
    echo ""
    echo "⚡ Exit with 'exit' or Ctrl+D to return to clean environment"
    echo "=========================================="
    echo ""
  '';
  
  # Set environment variables
  NIX_SHELL_PRESERVE_PROMPT = "1";
}