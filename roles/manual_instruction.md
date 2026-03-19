# Terminal environment — manual setup (Fedora)

This is the manual equivalent of the `alacritty`, `tmux`, and `zsh` Ansible roles.
Follow each section in order.

---

## 1. Prerequisites

These packages are expected to already be installed (via DNF):

```bash
sudo dnf install alacritty tmux zsh fira-code-fonts
```

For the Nerd Font variant (required for powerlevel10k icons), download and install manually:

```bash
# download FiraCode Nerd Font
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip FiraCode.zip -d ~/.local/share/fonts/FiraCode
fc-cache -fv
```

---

## 2. Alacritty

Create the config directory and file:

```bash
mkdir -p ~/.config/alacritty
nano ~/.config/alacritty/alacritty.toml
```

Paste the following:

```toml
[terminal]
shell = "/bin/zsh"

[font]
size = 12

[font.normal]
family = "FiraCode Nerd Font Mono"

[font.bold]
family = "FiraCode Nerd Font Mono"

[font.italic]
family = "FiraCode Nerd Font Mono"

[window]
opacity = 0.72
decorations = "buttonless"
dynamic_title = true

[window.padding]
x = 10
y = 10

[scrolling]
history = 5000
multiplier = 3

[selection]
save_to_clipboard = true

[colors.primary]
background = "#232526"
foreground = "#cdd6f4"

[colors.selection]
background = "#585b70"
text = "#cdd6f4"
```

---

## 3. Tmux

Create the config directory and file:

```bash
mkdir -p ~/.config/tmux
nano ~/.config/tmux/tmux.conf
```

Paste the following:

```bash
set -g default-shell /bin/zsh
set -g default-terminal "xterm-256color"
set -g history-limit 5000
set -g base-index 1
set -g mouse on

setw -g pane-base-index 1

set -g renumber-windows on

# reduce escape-time for neovim
set -sg escape-time 10
```

---

## 4. Zsh + zinit + powerlevel10k

### 4.1 Set system default shell to bash (stability)

```bash
chsh -s /bin/bash
```

### 4.2 Clone zinit

```bash
mkdir -p ~/.local/share/zinit
git clone --depth=1 https://github.com/zdharma-continuum/zinit.git \
    ~/.local/share/zinit/zinit.git
```

### 4.3 Create ~/.zshrc

```bash
nano ~/.zshrc
```

Paste the following:

```bash
# zinit
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# p10k wizard output (added automatically on first terminal open)
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
```

### 4.4 Set alacritty to launch zsh

This is already handled by the alacritty config above (`shell = "/bin/zsh"`).
The system shell remains bash — zsh is only the interactive terminal shell.

### 4.5 First launch

Open Alacritty. Zinit will bootstrap itself and the powerlevel10k wizard
will launch automatically. Follow the wizard — it writes `~/.p10k.zsh`
on completion. This file is yours and will not be touched by Ansible.

---

## Notes

- The system default shell is intentionally kept as `bash` so that scripts,
  cron jobs, and non-interactive sessions do not depend on zsh.
- Alacritty launches zsh directly via its `shell` config key — no `chsh` needed
  for the terminal experience.
- Zinit updates are manual: run `zinit self-update` inside a zsh session whenever needed.
- Tmux config takes effect on next `tmux` launch, or run `tmux source ~/.config/tmux/tmux.conf`
  inside an active session.
