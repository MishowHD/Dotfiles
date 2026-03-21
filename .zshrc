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
autoload -Uz vcs_info
autoload -Uz add-zsh-hook


# =============================================================================
#  History
# =============================================================================

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt append_history      # append to $HISTFILE on exit, never overwrite
setopt inc_append_history  # write each command immediately (survives crashes)
setopt share_history       # share history in real time across all open shells
setopt hist_ignore_dups    # do not record a command already in the previous entry
setopt hist_ignore_space   # do not record commands prefixed with a space
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
unsetopt prompt_sp           # suppress blank line before prompt

stty stop undef              # prevent Ctrl+S from freezing the terminal


# =============================================================================
#  Keybindings
# =============================================================================

# Emacs keymap provides Ctrl+A/E/W/U/L out of the box
bindkey -e

# Up/Down: prefix-aware history search instead of plain recall
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

bindkey '^R' fzf-history-widget


# =============================================================================
#  fzf
#
#  Ctrl+R  interactive history search
#  Ctrl+T  fuzzy file picker
#  Alt+C   fuzzy cd
#
#  --color 16 uses the terminal's own palette, follows the Ghostty theme
# =============================================================================

command -v fzf &>/dev/null && source <(fzf --zsh)

export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 40%"
export FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-sort --no-preview"


# =============================================================================
#  Exports
# =============================================================================

export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export PAGER=bat
export PATH="$HOME/.local/bin:$PATH"


# =============================================================================
#  Aliases
# =============================================================================

alias c='clear'
alias ff='fastfetch'
alias v='$EDITOR'
alias cat='bat --style=plain'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

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


# =============================================================================
#  Plugins
#
#  Must be sourced after all bindkey calls — wraps zle widgets internally
# =============================================================================

[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# =============================================================================
#  Git prompt (vcs_info)
# =============================================================================

setopt PROMPT_SUBST

zstyle ':vcs_info:*'     enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr   ' %F{3}●%f'
zstyle ':vcs_info:git:*' stagedstr     ' %F{2}✚%f'
zstyle ':vcs_info:git:*' formats       ' %F{4} %b%u%c%f'
zstyle ':vcs_info:git:*' actionformats ' %F{4} %b %F{1}(%a)%u%c%f'

# add-zsh-hook appends to the hook array instead of overwriting precmd()
add-zsh-hook precmd vcs_info


# =============================================================================
#  Prompt
# =============================================================================

# ANSI palette slots 0–15 — recolor automatically with the Ghostty theme:
#   %K{0}/%K{8}/%K{7}  dark → mid → light background blocks
#   %F{15}/%F{0}        bright/dark foreground for contrast
#
# %D{%_I:%M%P}        native zsh strftime, no subprocess fork
# \${vcs_info_msg_0_}  escaped so it expands at redraw, not at assignment

NEWLINE=$'\n'
PROMPT="${NEWLINE}%K{0}%F{15} %D{%_I:%M%P} %K{8}%F{15} %n %K{7}%F{0} %~ %f%k\${vcs_info_msg_0_} ❯ "

# Welcome line — printed once at startup
# ANSI base codes (palette-aware): 34=blue 32=green 33=yellow
echo -e "${NEWLINE}\e[34m it's $(print -P '%D{%_I:%M%P}') \e[32m $(uptime -p | cut -c 4-) \e[33m $(uname -r) \e[0m"


# =============================================================================
#  Tools
# =============================================================================

# Frecency-aware cd — --cmd cd makes it a transparent drop-in replacement
eval "$(zoxide init --cmd cd zsh)"
