# Cleanup NixOS


nix flake update --flake ~/.config/flakes/
sudo nixos-rebuild switch --flake ~/.config/flakes/#neptune
home-manager switch --flake ~/.config/flakes/#borges

sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
nix-env --delete-generations old --profile ~/.nix-profile

home-manager expire-generations --older-than 0d
nix-collect-garbage -d

sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old

sudo nix-collect-garbage -d &&
sudo nix-store --gc &&
sudo nix-store --optimise &&
sudo nix-store --verify --check-contents --repair