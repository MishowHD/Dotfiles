# =============================================================================
#  .zshrc — Giacomo's shell configuration
# =============================================================================

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------
HISTFILE=~/.zsh_history    # where to persist history across sessions
HISTSIZE=10000             # max entries kept in memory
SAVEHIST=10000             # max entries written to HISTFILE
setopt append_history      # append to history file instead of overwriting it
setopt hist_ignore_dups    # don't record consecutive duplicate commands
setopt hist_ignore_space   # commands prefixed with a space are not recorded
setopt hist_find_no_dups   # skip duplicates when searching history (even non-consecutive)
setopt share_history       # share history in real-time across all open shells

# -----------------------------------------------------------------------------
# Completions
# -----------------------------------------------------------------------------
autoload -Uz compinit
compinit                                                         # initialize the completion system
zstyle ':completion:*' menu select                               # navigate completions with arrow keys
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'              # case-insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"          # colorize completion list

# -----------------------------------------------------------------------------
# Keybindings
# -----------------------------------------------------------------------------
bindkey -e                                                       # use emacs-style keybindings (Ctrl+A, Ctrl+E, etc.)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search                       # Up arrow: search history by current prefix
bindkey '^[[B' down-line-or-beginning-search                     # Down arrow: search history by current prefix

# -----------------------------------------------------------------------------
# Shell options
# -----------------------------------------------------------------------------
setopt interactivecomments # allow comments with # in interactive shell

# -----------------------------------------------------------------------------
# Plugins
# -----------------------------------------------------------------------------
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  # command syntax highlighting

# -----------------------------------------------------------------------------
# Exports
# -----------------------------------------------------------------------------
export EDITOR=nvim                                  # default text editor
export MANPAGER="sh -c 'col -bx | bat -l man -p'"   # render man pages with bat
export MANROFFOPT="-c"                              # needed for correct bat man rendering
export PAGER=bat                                    # use bat as default pager
export PATH="$HOME/.local/bin:$PATH"                # include user-local binaries

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
alias c='clear'                                                  # quick clear
alias ff='fastfetch'                                             # system info (run manually)
alias l='eza --icons=always'                                     # modern ls replacement with icons
alias la='eza -al --icons=always'                                # long listing with hidden files
alias ll='eza -l --icons=always'                                 # long listing without hidden files
alias lt='eza -a --tree --level=2 --icons=always'                # show files in tree format
alias v='$EDITOR'                                                # open editor
alias k='kubectl'                                                # kubernetes shorthand
alias cat='bat --style=plain'                                    # cat replacement with syntax highlighting
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'    # regenerate grub config

# -----------------------------------------------------------------------------
# Prompt & Tools
# -----------------------------------------------------------------------------
eval "$(starship init zsh)"         # starship prompt
eval "$(zoxide init --cmd cd zsh)"  # zoxide as a drop-in cd replacement
