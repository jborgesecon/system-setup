# Neptune Workstation Build Guide

This document captures the end-to-end process for provisioning a brand-new **Neptune** workstation using the Ansible playbooks in this repo. Follow the steps in order; everything is designed for Fedora Server (current release) with KDE Plasma as the desktop environment.

> ⚙️ **Goal:** Clean Fedora install + desktop + repo checkout + `ansible-wrapper` run that converges Neptune to the desired state.

## Quick checklist

1. ✅ Install Fedora Server (latest ISO) on the target hardware.
2. ✅ Update the system and install CLI tooling (dnf, git, ansible).
3. ✅ Install the KDE Plasma desktop group and make SDDM the default display manager.
4. ✅ Clone this repository and review the Neptune inventory variables.
5. ✅ Run the Neptune rebuild play (`./scripts/ansible-wrapper.sh rebuild Neptune -K`).

Each step is detailed below with exact commands for copy/paste convenience.

## 1. Prepare Fedora Server

1. Boot from the Fedora Server installer and perform a standard installation. Use the default partitioning scheme unless Neptune has special storage requirements.
2. After the first reboot, log in on the console and bring the system current:

	```bash
	sudo dnf update -y
	sudo dnf install -y git ansible
	```

	> Tip: If `ansible` comes from the Fedora repos you already have everything needed; no extra pip steps required.

## 2. Install the KDE desktop experience

1. Inspect the available desktop environment groups so you know what you're installing:

	```bash
	 sudo dnf group list --available "*desktop*"
	```

2. Install the KDE group (the `-y` flag is handy on a fresh box):

	```bash
	sudo dnf group install -y kde-desktop-environment
	```

3. Enable the SDDM login manager so KDE loads automatically on boot:

	```bash
	sudo systemctl enable sddm \\
    sudo systemctl set-default graphical.target
	```

4. Reboot and log into KDE once to let Plasma create its user profile:

	```bash
	sudo reboot
	```

## 3. Clone the automation repo

Once you land on KDE (or via SSH), clone the `system-setup` repo and move into it:

```bash
cd ~/workspace   # or wherever you keep infra repos
git clone https://github.com/jborgesecon/system-setup.git
cd system-setup
```

If you use SSH for GitHub, feel free to substitute your SSH remote.

## 4. Review Neptune inventory inputs

Before running automation, verify that the Neptune inventory reflects the new machine:

* `inventories/neptune/hosts.yml` – ensure hostnames/IPs match.
* `inventories/group_vars/neptune.yml` – customize host vars like disks, users, secrets (if required).

It’s a good idea to take a quick look at `configs/neptune/*` so you know what will be applied (docker settings, firewall rules, user dotfiles, etc.).

### Remote execution quickstart

If you plan to run Ansible from another machine:

1. Gather the host’s IP address:
	* Same LAN: `ip addr show`
	* Different network: `curl ipinfo.io`
2. Edit `./inventories/neptune/hosts.yml` and plug the IP into the appropriate host entry following the existing template.
3. Ensure SSH is available:

	```bash
	sudo systemctl enable --now sshd
	```

4. Need VPN details or SSH pub-key whitelisting? Reach out to the server support team; they’ll provision access and register your key.

## 5. Run the Neptune playbook

Use the wrapper script to apply the entire Neptune configuration. The `-K` flag tells Ansible to prompt for sudo privilege escalation:

```bash
./scripts/ansible-wrapper.sh rebuild Neptune -K
```

The script internally calls `ansible-playbook playbooks/build-neptune.yml` with the right inventory and tags, so you rarely need to invoke Ansible manually. Expect the first run to take several minutes while packages, containers, and dotfiles sync.

### Common flags

* `--limit <host>` – target a specific host in the Neptune inventory.
* `--tags <tag1,tag2>` – run just a subset (e.g., `system`, `user`).
* `--skip-tags <tag>` – skip heavy sections while debugging.

Example:

```bash
./scripts/ansible-wrapper.sh rebuild Neptune -K --tags user
```

## 6. Post-run verification

After Ansible finishes, spot-check a few critical services:

* **Docker:** `sudo systemctl status docker` and `docker ps`.
* **PostgreSQL:** `sudo systemctl status postgresql` and check ports.
* **Firewall:** confirm rules with `sudo firewall-cmd --list-all`.
* **User environment:** Log out/in to ensure dotfiles (Alacritty, Neovim, Zsh) are active.

If something failed, re-run the wrapper with `-vv` for verbose logs or re-apply only the failing tag.

## Troubleshooting notes

* Missing packages? Run `sudo dnf distro-sync` to clean up, then retry.
* SSH issues reaching the box? Update `inventories/neptune/hosts.yml` with the correct IP/FQDN and ensure the host key is trusted.
* Authentication prompts: supply the same sudo password you use locally when Ansible asks via `-K`.

With these steps the Neptune workstation should be fully provisioned and aligned with the repo’s desired state.