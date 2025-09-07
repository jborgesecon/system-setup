#!/usr/bin/env bash
#
# setup_project.sh
# A script to bootstrap a new project by:
# 1. Copying a template shell.nix if one doesn't exist.
# 2. Setting up direnv to use the Nix environment.

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# Define the path to your global template file.
# Using $HOME is more robust in scripts than '~'.
TEMPLATE_PATH="$HOME/Projects/personal/shell.nix"
DEST_FILE="shell.nix"

# --- Pre-flight Checks ---
# 1. Check if direnv is installed and available in the PATH.
if ! command -v direnv &> /dev/null; then
    echo "🔴 Error: direnv command not found."
    echo "   Please install direnv and hook it into your shell first."
    exit 1
fi

# 2. Check if the template file actually exists before we do anything.
if [ ! -f "$TEMPLATE_PATH" ]; then
    echo "🔴 Error: Template file not found at '$TEMPLATE_PATH'"
    echo "   Please check the TEMPLATE_PATH variable in the script."
    exit 1
fi

# --- Main Logic ---
echo "✅ Bootstrapping Nix environment for this project..."

# 1. Copy the template shell.nix IF one doesn't already exist.
if [ -f "$DEST_FILE" ]; then
    echo "  -> Found existing '$DEST_FILE'. Skipping copy."
else
    echo "  -> No '$DEST_FILE' found. Copying template..."
    cp "$TEMPLATE_PATH" "$DEST_FILE"
    echo "  -> Copied template to the current directory."
fi

# 2. Set up .envrc to use the local shell.nix
ENVRC_FILE=".envrc"
NIX_DIRECTIVE="use nix"

echo "  -> Ensuring '$NIX_DIRECTIVE' is in $ENVRC_FILE..."
# This grep/|| pattern ensures the line is only added if it's not already there.
if ! grep -qF "$NIX_DIRECTIVE" "$ENVRC_FILE" 2>/dev/null; then
    echo "$NIX_DIRECTIVE" >> "$ENVRC_FILE"
fi

# 3. Authorize direnv for the current directory.
echo "  -> Running 'direnv allow' to authorize and load environment."
direnv allow .

echo ""
echo "🎉 Success! Project is now set up with a local '$DEST_FILE' and managed by direnv."
nix-shell
