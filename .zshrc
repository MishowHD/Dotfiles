# =============================================================================
#  .zshrc — Giacomo's shell configuration
# =============================================================================

# -----------------------------------------------------------------------------
# Modules
# -----------------------------------------------------------------------------
zmodload zsh/complist                    # arrow-key navigation in completion menu
autoload -Uz compinit && compinit        # completion system
autoload -U  colors   && colors          # %F{} %K{} prompt color support
autoload -Uz vcs_info                    # git branch/status for the prompt

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt append_history        # append to HISTFILE on exit instead of overwriting
setopt inc_append_history    # write each command immediately (survives crashes)
setopt share_history         # share history across all open shells
setopt hist_ignore_dups      # skip consecutive duplicate entries
setopt hist_ignore_space     # skip commands prefixed with a space
setopt hist_find_no_dups     # skip duplicates when searching

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------
zstyle ':completion:*' menu select                         # arrow-key menu
zstyle ':completion:*' special-dirs true                   # show . and .. 
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # colorize entries
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case-insensitive
zstyle ':completion:*' squeeze-slashes false               # allow /*/ expansion

# -----------------------------------------------------------------------------
# Shell options
# -----------------------------------------------------------------------------
setopt auto_param_slash      # append / instead of space after a completed dir
setopt no_case_glob          # case-insensitive globbing
setopt no_case_match         # case-insensitive pattern matching
setopt globdots              # include dotfiles in glob results
setopt extended_glob         # enable ^ ~ # glob operators
setopt interactive_comments  # allow # comments in interactive shell
unsetopt prompt_sp           # suppress blank line before prompt

stty stop undef              # disable Ctrl+S terminal freeze

# -----------------------------------------------------------------------------
# Keybindings
# — emacs map (-e) already provides Ctrl+A/E/W/U/L; only additions below
# — Up/Down: prefix-aware history search (type "git", press Up → only git cmds)
# — Ctrl+R:  fzf interactive history picker
# -----------------------------------------------------------------------------
bindkey -e

bindkey '^H'       backward-kill-word   # Ctrl+Backspace: delete previous word
bindkey '^[[1;5C'  forward-word         # Ctrl+Right: next word
bindkey '^[[1;5D'  backward-word        # Ctrl+Left:  previous word

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

bindkey '^R' fzf-history-widget

# -----------------------------------------------------------------------------
# fzf — fuzzy finder
# — Ctrl+R: interactive history search (replaces default reverse-i-search)
# — Ctrl+T: fuzzy file picker          (Alt+C: fuzzy cd — learn when ready)
# — --color 16: uses the terminal's palette so it follows the Ghostty theme
# -----------------------------------------------------------------------------
command -v fzf &>/dev/null && source <(fzf --zsh)

export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 40%"
export FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-sort --no-preview"

# -----------------------------------------------------------------------------
# Exports
# -----------------------------------------------------------------------------
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox
export MANPAGER="sh -c 'col -bx | bat -l man -p'"  # man pages rendered with bat
export MANROFFOPT="-c"
export PAGER=bat
export PATH="$HOME/.local/bin:$PATH"

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# Plugins
# — must be sourced last, after all bindkey calls (wraps zle widgets internally)
# -----------------------------------------------------------------------------
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# -----------------------------------------------------------------------------
# Git prompt (vcs_info)
# — precmd hook populates ${vcs_info_msg_0_} before every prompt redraw
# — check-for-changes runs 'git status' each redraw; disable in huge repos
# — ANSI slots follow the Ghostty theme: 4=blue 3=yellow 2=green 1=red
# -----------------------------------------------------------------------------
setopt PROMPT_SUBST

zstyle ':vcs_info:*'     enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr   ' %F{3}●%f'   # unstaged changes
zstyle ':vcs_info:git:*' stagedstr     ' %F{2}✚%f'   # staged changes
zstyle ':vcs_info:git:*' formats       ' %F{4} %b%u%c%f'
zstyle ':vcs_info:git:*' actionformats ' %F{4} %b %F{1}(%a)%u%c%f'

precmd() { vcs_info }

# -----------------------------------------------------------------------------
# Prompt
# — ANSI slots 0–15 remap with the Ghostty theme automatically
#     %K{0}/%K{8}/%K{7}: dark→mid→light background blocks
#     %F{15}/%F{0}:       bright/dark text for contrast
# — %D{%_I:%M%P}: native zsh strftime, no subprocess fork
# — \${vcs_info_msg_0_}: escaped so it expands at redraw, not at assignment
# -----------------------------------------------------------------------------
NEWLINE=$'\n'
PROMPT="${NEWLINE}%K{0}%F{15} %D{%_I:%M%P} %K{8}%F{15} %n %K{7}%F{0} %~ %f%k\${vcs_info_msg_0_} ❯ "

# Welcome line: printed once at startup — time, uptime, kernel
# \e[3Xm uses ANSI base codes (palette-aware): 34=blue 32=green 33=yellow
echo -e "${NEWLINE}\e[34m it's $(print -P '%D{%_I:%M%P}') \e[32m $(uptime -p | cut -c 4-) \e[33m $(uname -r) \e[0m"

# -----------------------------------------------------------------------------
# Tools
# — zoxide: frecency-aware cd, --cmd cd makes it a transparent drop-in
# -----------------------------------------------------------------------------
eval "$(zoxide init --cmd cd zsh)"
