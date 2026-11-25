# Ansible Profiles

This repository provides a declarative way to manage Fedora systems using Ansible.  
Profiles (e.g., **Saturn** for academic/research, **Neptune** for personal/portfolio) define package sets and configurations that can be rebuilt reproducibly.

---

## Structure

```
.
├── inventories/        # Profiles and variables
│   ├── neptune/        # Neptune profile inventory (hosts.yml, group_vars, host_vars)
│   └── saturn/         # Saturn profile inventory
├── playbooks/          # Entry points for rebuild/clean (build-neptune.yml, build-saturn.yml)
├── roles/              # Modular system and application roles
│   ├── alacritty/      # Terminal emulator config
│   ├── core_packages/  # DNF, COPR, RPM repos, and Flatpak management
│   ├── neovim/         # LazyVim setup
│   ├── postgresql/     # PostgreSQL cluster, pg_hba.conf, and user provisioning
│   ├── publishing_tools/ # Quarto, Typst, and Marp CLI
│   ├── python/         # Centralized /opt/python-data virtual environment & CLI symlinks
│   ├── r_lang/         # R + R-CoprManager (bspm bridge)
│   ├── tmux/           # Tmux config and TPM
│   ├── virtualbox/     # VirtualBox + akmods kernel module setup
│   └── zsh/            # Zsh + Zinit + Powerlevel10k + aliases
├── scripts/            # Helper scripts (ansible-wrapper.sh, deploy-configs.sh, rollback.sh)
└── README.md
```

---

## Usage

- **Rebuild a profile**  
  ```bash
  ./scripts/ansible-wrapper.sh rebuild Neptune -K
  ```
  Installs packages and applies configs for the selected profile (`Neptune` or `Saturn`).

- **Run a single role or subset via `--tags`**  
  Every role in `playbooks/build-neptune.yml` is tagged (`core_packages`, `python`, `postgresql`, `r_lang`, `alacritty`, `tmux`, `zsh`, `neovim`, `virtualbox`, `publishing_tools`, `configs`):
  ```bash
  # Run only the Python role
  ./scripts/ansible-wrapper.sh rebuild Neptune -K --tags python

  # Apply only dotfile/shell configuration roles (alacritty, tmux, zsh, neovim)
  ./scripts/ansible-wrapper.sh configs Neptune -K
  ```

- **Clean system**  
  ```bash
  ./scripts/ansible-wrapper.sh clean Neptune -K
  ```
  Removes profile-managed packages marked for cleanup.

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

---

## Python Environment Architecture (`/opt/python-data`)

Neptune uses a centralized, Ansible-managed Python virtual environment at `/opt/python-data` (`--no-system-site-packages`) rather than scattering packages across DNF, `pipx`, and global `pip`:

- **Vanilla System Python (`python3` / `/usr/bin/python3`)**: Reserved strictly for Fedora system components and RPM dependencies.
- **Data Science & Application Python (`/opt/python-data`)**: Contains the complete scientific, data engineering, web, and application stack (`numpy`, `pandas`, `polars`, `duckdb`, `pyarrow`, `scipy`, `scikit-learn`, `statsmodels`, `matplotlib`, `seaborn`, `plotly`, `sqlalchemy`, `psycopg2-binary`, `fastapi`, `flask`, `streamlit`, `jupyterlab`, `ipykernel`, `yfinance`, `faker`).

### Terminal Commands & Aliases

| Command / Alias | Target | Purpose |
| :--- | :--- | :--- |
| `python3` | `/usr/bin/python3` | Default Fedora system (vanilla) Python |
| `python-data` | `/opt/python-data/bin/python` | Global executable & Zsh alias for the data science environment |
| `pyd` | `/opt/python-data/bin/python` | Short Zsh alias for `/opt/python-data/bin/python` |
| `pip-data` | `/opt/python-data/bin/pip` | Global executable for managing `/opt/python-data` packages |
| `jupyter-lab` / `jupyter` | `/opt/python-data/bin/jupyter-lab` | Launches JupyterLab pinned to the `Python 3 (python-data)` kernel |
| `streamlit` | `/opt/python-data/bin/streamlit` | Runs Streamlit using `/opt/python-data` libraries |

### Adding a New Python Package

1. **Quick ad-hoc install (no full Ansible run needed):**
   Install the package immediately into `/opt/python-data`:
   ```bash
   sudo pip-data install <package-name>
   ```
   Then add `- <package-name>` to `python_data_packages` in `roles/python/defaults/main.yml` so it is tracked for future rebuilds.
2. **Or install declaratively via the `python` tag:**
   Add `- <package-name>` to `roles/python/defaults/main.yml` and run only the `python` role:
   ```bash
   ./scripts/ansible-wrapper.sh rebuild Neptune -K --tags python
   ```

---

## Layers

1. **Vanilla apps** → Installed via dnf, rpm, flatpak (no config changes).  
2. **User configs** → Dotfiles and `~/.config` (e.g., Neovim, Zsh, Alacritty, Tmux).  
3. **System configs** → `/etc` and `/opt` services & runtimes (e.g., `/opt/python-data`, PostgreSQL, VirtualBox).  
4. **System setup** → Networking, firewall, localhost subdomains.

---

## Profiles

- **Saturn** → Academic/research environment (Fedora, PostgreSQL, Docker, Neovim).  
- **Neptune** → Personal/data-science workstation environment (Fedora, `/opt/python-data`, R/CRAN, PostgreSQL, Quarto/Typst, Brave, VSCode, shell configs).

---

## Goal

Provide a reproducible, declarative system setup similar to Nix, but implemented with Ansible for Fedora.
