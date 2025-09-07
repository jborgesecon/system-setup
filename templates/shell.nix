{ pkgs ? import <nixpkgs> {} }:

let
  # --- Python Package Management from requirements.txt ---

  requirementsPath = ./requirements.txt;
  hasRequirements = builtins.pathExists requirementsPath;

  # Helper function to parse a requirements.txt file.
  # It extracts package names, normalizes them for nixpkgs (e.g., "scikit-learn" -> "scikit_learn"),
  # and discards version specifiers and comments.
  parseRequirements = text:
    let
      lines = pkgs.lib.splitString "\n" text;
      # Filter out comments and empty lines
      nonEmptyLines = pkgs.lib.lists.filter (line: line != "" && !pkgs.lib.hasPrefix "#" line) lines;
      packageNames = map (line:
        let
          # Remove version specifiers like ==, >=, etc., to get the base package name
          cleaned = pkgs.lib.lists.head (pkgs.lib.splitString "==" (pkgs.lib.lists.head (pkgs.lib.splitString ">=" (pkgs.lib.lists.head (pkgs.lib.splitString "<=" (pkgs.lib.lists.head (pkgs.lib.splitString "~=" line)))))));
          # Normalize name: convert to lowercase and replace hyphens with underscores
          normalized = pkgs.lib.replaceStrings ["-"] ["_"] (pkgs.lib.toLower cleaned);
        in
          normalized
      ) nonEmptyLines;
    in
      packageNames;

  # Get the list of package names if requirements.txt exists, otherwise an empty list.
  pythonPackageNames = if hasRequirements
    then parseRequirements (builtins.readFile requirementsPath)
    else [];

  # Create the Python environment.
  # `withPackages` takes a function that receives the Python package set (ps)
  # and returns a list of packages to include in the environment.
  pythonEnv = pkgs.python312.withPackages (ps:
    let
      # This function safely retrieves a package by name from the Nix package set.
      # If the package doesn't exist, it prints a helpful warning and returns null.
      getPackage = name:
        if builtins.hasAttr name ps then
          ps.${name}
        else
          # `builtins.trace` provides a warning during Nix evaluation without stopping it.
          builtins.trace "⚠️  Warning: Python package '${name}' not found in nixpkgs. Skipping." null;

      # 1. Map over our list of package names to get the actual package derivations.
      # 2. Filter out any packages that were not found (which are null).
      packages = pkgs.lib.lists.filter (p: p != null) (map getPackage pythonPackageNames);
    in
      packages
  );

  # --- System Dependencies & Shell Configuration ---

  # Get the path to the C++ standard library, needed for many scientific packages.
  libstdcppPath = pkgs.stdenv.cc.cc.lib + "/lib";

in
pkgs.mkShell {
  # These are the packages and libraries that will be available in the shell.
  buildInputs = [
    # Our custom Python environment with packages from requirements.txt
    pythonEnv

    # Essential system libraries needed for building Python packages with C/C++ or Fortran extensions.
    pkgs.zlib          # Compression library (e.g., for pandas, Pillow)
    pkgs.gcc           # GNU Compiler Collection
    pkgs.libffi        # Foreign Function Interface library
    pkgs.openssl       # SSL/TLS library (for requests, cryptography)
    pkgs.zeromq        # Messaging library (for jupyter, pyzmq)
    pkgs.pkg-config    # Tool to help configure build flags
    pkgs.gfortran      # Fortran compiler (for scipy, numpy)

    # Common libraries for data science, web development, and general purpose use.
    pkgs.sqlite        # SQLite database library
    pkgs.libxml2       # XML parsing library
    pkgs.libxslt       # XSLT transformation library
    pkgs.freetype      # Font rendering (for matplotlib)
    pkgs.cairo         # 2D graphics library
  ];

  # This hook is a script that runs every time you enter the shell.
  shellHook = ''
    # Add system libraries to the dynamic linker's search path. This is crucial
    # for Python packages with native extensions to find their dependencies at runtime.
    export LD_LIBRARY_PATH="${libstdcppPath}:$LD_LIBRARY_PATH"

    # Unset this variable to avoid potential issues with build determinism in some tools.
    unset SOURCE_DATE_EPOCH

    # Welcome message to confirm the environment is set up.
    echo "✅ Nix environment is ready."
    echo "   Python: $(python --version)"
    ${if hasRequirements then ''echo "   Packages from requirements.txt have been loaded."'' else ''echo "   No requirements.txt found. Using base Python environment."''}
    echo ""
    ${if !hasRequirements then ''echo "💡 Tip: Create a requirements.txt file and run 'direnv reload' or 'nix-shell' to install packages."'' else ''''}
  '';
}
