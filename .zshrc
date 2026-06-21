# =============================================================================
#  .zshrc — Giacomo's zsh configuration
# =============================================================================


# =============================================================================
#  Modules
# =============================================================================

# zsh/complist must be loaded before compinit so menu-select is defined correctly
zmodload zsh/complist
autoload -Uz compinit && compinit
autoload -U  colors   && colors


# =============================================================================
#  History
# =============================================================================

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt share_history       # share history in real time across all open shells
setopt hist_ignore_dups    # skip consecutive duplicate entries
setopt hist_ignore_space   # skip commands prefixed with a space
setopt hist_find_no_dups   # skip duplicates when navigating history


# =============================================================================
#  Completion
# =============================================================================

zstyle ':completion:*' menu select                         # arrow-key navigation
zstyle ':completion:*' special-dirs true                   # include . and ..
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # colorize entries
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case-insensitive
zstyle ':completion:*' squeeze-slashes false               # preserve /*/ glob expansion


# =============================================================================
#  Shell options
# =============================================================================

setopt auto_param_slash      # append / when completing a directory
setopt no_case_glob          # case-insensitive globbing
setopt no_case_match         # case-insensitive pattern matching
setopt globdots              # include dotfiles in glob results
setopt extended_glob         # enable ^, ~, # glob operators
setopt interactive_comments  # allow # comments in interactive shell

stty stop undef              # prevent Ctrl+S from freezing the terminal


# =============================================================================
#  Keybindings
# =============================================================================

bindkey -e


# =============================================================================
#  fzf
#
#  source <(fzf --zsh) automatically binds:
#    Ctrl+R  interactive history search
#    Ctrl+T  fuzzy file picker
#    Alt+C   fuzzy cd
#
#  --color 16 uses the terminal's own palette
# =============================================================================

if command -v fzf &>/dev/null; then
  source <(fzf --zsh)

  export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 40%"
  export FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-preview"
fi


# =============================================================================
#  Exports
# =============================================================================

export EDITOR=nvim
export BROWSER=firefox
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export PATH="$HOME/.local/bin:$PATH"


# =============================================================================
#  Aliases
# =============================================================================

alias c='clear'
alias ff='fastfetch'
alias v='$EDITOR'
alias cat='bat --style=plain'

alias l='eza --icons=always'
alias ls='eza --icons=always'
alias la='eza -al --icons=always'
alias ll='eza -l --icons=always'
alias lt='eza -a --tree --level=2 --icons=always'

alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

alias k='kubectl'
alias kx='kubectx'

# =============================================================================
#  Plugins
#
#  Must be sourced after all bindkey calls — wraps zle widgets internally
# =============================================================================

source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh

# =============================================================================
#  Prompt & Welcome
# =============================================================================

NEWLINE=$'\n'

# Welcome line: showing date, uptime and kernel version
print -P "${NEWLINE}%F{4} it's %D{%A, %B %d} %F{2} $(uptime -p | cut -c 4-) %F{3} $(uname -r) %f"

# Initialize Starship (Modern, fast and functional prompt)
eval "$(starship init zsh)"


# =============================================================================
#  Tools
# =============================================================================

# Frecency-aware cd — --cmd cd makes it a transparent drop-in replacement
eval "$(zoxide init --cmd cd zsh)"
