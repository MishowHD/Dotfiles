# -----------------------------------------------------
# Exports
# -----------------------------------------------------
export EDITOR=nvim
export ZSH="$HOME/.oh-my-zsh"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export PAGER=bat

# -----------------------------------------------------
# oh-my-zsh plugins
# -----------------------------------------------------
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Set-up oh-my-zsh
source $ZSH/oh-my-zsh.sh

# zsh history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# -----------------------------------------------------
# Prompt
# -----------------------------------------------------
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
(cat ~/.cache/wal/sequences &)

# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------
alias c='clear'
alias ff='fastfetch'
alias ls='eza --icons=always'
alias la='eza -al --icons=always'
alias v='$EDITOR'
alias k='kubectl'
alias cat='bat --style=plain'

# -----------------------------------------------------
# System
# -----------------------------------------------------
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
