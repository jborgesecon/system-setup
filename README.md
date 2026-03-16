# Ansible Nixlike Profiles

This repository provides a declarative way to manage Fedora systems using Ansible.  
Profiles (e.g., **Saturn** for academic/research, **Neptune** for personal/portfolio) define package sets and configurations that can be rebuilt reproducibly.

---

## Structure

```
.
├── configs/            # Configuration templates
│   ├── setup/          # System setup (firewall, networking, subdomains)
│   ├── system/         # System-level configs (/etc)
│   └── user/           # User-level configs (~/.config, dotfiles)
├── inventories/        # Profiles and variables
│   ├── group_vars/     # Package lists and config references
│   ├── neptune/         # Neptune profile inventory
│   └── saturn/         # Saturn profile inventory
├── playbooks/          # Entry points for rebuild/clean
├── roles/              # Package manager roles
│   ├── dnf/
│   ├── rpm/
│   └── flatpak/
├── scripts/            # Helper scripts (wrapper, cleanup)
└── README.md
```

---

## Usage

- **Rebuild a profile**  
  ```bash
  ./scripts/ansible-wrapper.sh rebuild Saturn
  ```
  Installs packages and applies configs for the Saturn profile.

- **Clean system**  
  ```bash
  ./scripts/ansible-wrapper.sh clean Saturn
  ```
  Removes non‑profile packages and restores defaults.

### Prerequisites

1. Install Ansible (Fedora example):
  ```bash
  sudo dnf install ansible
  ```
  or run commands through `nix-shell -p ansible` on Nix-based hosts.
2. Install the required collections once per machine:
  ```bash
  ansible-galaxy collection install -r collections/requirements.yml
  ```

### Saturn workflow

```bash
# Full rebuild (packages + configs)
./scripts/ansible-wrapper.sh rebuild Saturn

# Apply only config files (useful after tweaking configs/)
./scripts/deploy-configs.sh Saturn

# Remove managed configs without touching packages
./scripts/rollback.sh Saturn

# Full cleanup (packages, services, configs)
./scripts/ansible-wrapper.sh clean Saturn
```

Each helper script accepts additional `ansible-playbook` arguments. For example, pass `--tags packages` to apply only package-related tasks or `--limit saturn` to target specific hosts in the inventory.

---

## Layers

1. **Vanilla apps** → Installed via dnf, rpm, flatpak (no config changes).  
2. **User configs** → Dotfiles and `~/.config` (e.g., Neovim, Zsh, Alacritty).  
3. **System configs** → `/etc` services (e.g., PostgreSQL, Docker, OpenVPN).  
4. **System setup** → Networking, firewall, localhost subdomains.

---

## Profiles

- **Saturn** → Academic/research environment (Fedora, PostgreSQL, Docker, Neovim).  
- **Radial** → Personal/portfolio environment (Fedora, Brave, VSCode, shell configs).

---

## Goal

Provide a reproducible, declarative system setup similar to Nix, but implemented with Ansible for Fedora.