{ pkgs ? import <nixpkgs> { 
    config.allowUnfree = true;
    config.allowInsecure = true;
  }
}:

pkgs.mkShell {
  name = "insecure-shell";
  
  buildInputs = with pkgs; [
    # Add insecure packages here
    # Example: ventoy-full
  ];
  
  shellHook = ''
    echo "🔓 Insecure Shell Environment"
    echo "This shell allows insecure and unfree packages."
    echo "Use with caution - packages here may have security issues."
    echo ""
    echo "Available commands will be isolated to this shell session."
    echo "Exit with 'exit' or Ctrl+D to return to your clean environment."
    echo ""
  '';
}