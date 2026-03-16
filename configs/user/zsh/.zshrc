# Saturn profile Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export VISUAL="nvim"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Prompt theme
ZSH_THEME="agnoster"

# Plugins tuned for research + dev
plugins=(git sudo zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Path adjustments
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# Aliases
alias k='kubectl'
alias g='git'
alias gs='git status --short --branch'
alias v='nvim'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias ..='cd ..'

# Python virtualenv helper
mkvenv() {
  python3 -m venv "$1"
  source "$1/bin/activate"
}

# Auto-start tmux when available
if command -v tmux >/dev/null 2>&1; then
  if [ -z "$TMUX" ]; then
    tmux new-session -A -s saturn
  fi
fi
