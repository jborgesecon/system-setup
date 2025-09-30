# Cleanup NixOS

nix flake update --flake ~/.config/flakes/

sudo nixos-rebuild switch --flake ~/.config/flakes/#neptune

home-manager switch --flake ~/.config/flakes/#borges


sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system

nix-env --delete-generations old --profile ~/.nix-profile

sudo nix-collect-garbage -d

sudo nix-store --gc


sudo nix-store --optimise

sudo nix-store --verify --check-contents --repair
