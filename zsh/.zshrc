# -----------------------------------------------------
# Exports
# -----------------------------------------------------
export EDITOR=nvim
export ZSH="$HOME/.oh-my-zsh"
export MANPAGER="nvim +Man!"

# -----------------------------------------------------
# oh-my-zsh plugins
# -----------------------------------------------------
plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
    copyfile
    copybuffer
    dirhistory
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

# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------

# -----------------------------------------------------
# General
# -----------------------------------------------------
alias c='clear'
alias ff='fastfetch'
alias ls='eza --icons=always'
alias la='eza -al --icons=always'
alias v='$EDITOR'
alias vim='$EDITOR'
alias k='kubectl'
alias cat='bat'
# -----------------------------------------------------
# System
# -----------------------------------------------------
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# -----------------------------------------------------
# AUTOSTART
# -----------------------------------------------------

# -----------------------------------------------------
# Fastfetch
# -----------------------------------------------------
if [[ $(tty) == *"pts"* ]]; then
    fastfetch
fi
