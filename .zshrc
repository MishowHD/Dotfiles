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
autoload -Uz add-zsh-hook  # appends to hook arrays instead of overwriting them


# =============================================================================
#  History
# =============================================================================

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt append_history      # append to $HISTFILE on exit, never overwrite
setopt inc_append_history  # write each command immediately (survives crashes)
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
unsetopt prompt_sp           # suppress blank line before prompt

stty stop undef              # prevent Ctrl+S from freezing the terminal


# =============================================================================
#  Keybindings
#
# =============================================================================

bindkey -e

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search


# =============================================================================
#  fzf
#  Ctrl+R  interactive history search
# =============================================================================

if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
  bindkey '^R' fzf-history-widget

  export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 40%"
  export FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-sort --no-preview"
fi


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
#  check-for-changes enables the %u (unstaged ●) and %c (staged ✚) markers
#  by running 'git status' on every prompt
# =============================================================================

setopt PROMPT_SUBST

zstyle ':vcs_info:*'     enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr   ' %F{3}●%f'
zstyle ':vcs_info:git:*' stagedstr     ' %F{2}✚%f'
zstyle ':vcs_info:git:*' formats       ' %F{4} %b%u%c%f'
zstyle ':vcs_info:git:*' actionformats ' %F{4} %b %F{1}(%a)%u%c%f'

add-zsh-hook precmd vcs_info


# =============================================================================
#  Prompt
# =============================================================================

NEWLINE=$'\n'
PROMPT="${NEWLINE}%K{0}%F{15} %D{%_I:%M%P} %K{8}%F{15} %n %K{7}%F{0} %~ %f%k\${vcs_info_msg_0_} ❯ "

# Welcome line — printed once at startup: time, uptime, kernel version
echo -e "${NEWLINE}\e[34m it's $(print -P '%D{%_I:%M%P}') \e[32m $(uptime -p | cut -c 4-) \e[33m $(uname -r) \e[0m"


# =============================================================================
#  Tools
# =============================================================================

# Frecency-aware cd — --cmd cd makes it a transparent drop-in replacement
eval "$(zoxide init --cmd cd zsh)"
