# =============================================================================
#  .zshrc — Giacomo's zsh configuration
#
#  Dependencies (install via pacman):
#    zsh-syntax-highlighting  eza  bat  fzf  zoxide  fastfetch
# =============================================================================


# =============================================================================
#  Modules
# =============================================================================

# zsh/complist must be loaded before compinit so the menu-select widget
# (used for arrow-key navigation in the completion menu) is correctly defined.
zmodload zsh/complist

# Initialize the completion system and load color support for prompts.
autoload -Uz compinit && compinit
autoload -U  colors   && colors

# vcs_info: built-in module that provides git branch/status to the prompt.
# add-zsh-hook: appends functions to hook arrays instead of overwriting them,
# which is required when multiple tools need the same hook (e.g. precmd).
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
zstyle ':completion:*' special-dirs true                   # include . and .. in menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # colorize entries
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case-insensitive matching
zstyle ':completion:*' squeeze-slashes false               # preserve /*/ glob expansion


# =============================================================================
#  Shell options
# =============================================================================

setopt auto_param_slash      # append / (not a space) when completing a directory
setopt no_case_glob          # case-insensitive filename globbing
setopt no_case_match         # case-insensitive pattern matching
setopt globdots              # include dotfiles in glob results without a leading dot
setopt extended_glob         # enable the ^, ~, and # glob operators
setopt interactive_comments  # allow # comments in an interactive shell
unsetopt prompt_sp           # suppress the blank line zsh inserts before some prompts

stty stop undef              # prevent Ctrl+S from accidentally freezing the terminal


# =============================================================================
#  Keybindings
# =============================================================================

# Use the emacs keymap as a base. It already provides the most common shortcuts:
#   Ctrl+A / Ctrl+E   move to beginning / end of line
#   Ctrl+W            delete the previous word
#   Ctrl+U            delete the entire line
#   Ctrl+L            clear the screen
bindkey -e

# Extra bindings on top of the emacs defaults.
bindkey '^H'       backward-kill-word   # Ctrl+Backspace — delete previous word
bindkey '^[[1;5C'  forward-word         # Ctrl+Right      — move to next word
bindkey '^[[1;5D'  backward-word        # Ctrl+Left       — move to previous word

# Replace plain up/down history recall with prefix-aware search:
# type "git" and press Up to cycle only through commands that started with "git".
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# Bind Ctrl+R to the fzf interactive history widget (configured below).
bindkey '^R' fzf-history-widget


# =============================================================================
#  fzf — fuzzy finder
#
#  source <(fzf --zsh) activates three shell widgets:
#    Ctrl+R   interactive history search (replaces the default reverse-i-search)
#    Ctrl+T   fuzzy file picker
#    Alt+C    fuzzy cd into a subdirectory
#
#  --color 16 tells fzf to use the terminal's own 16-color palette so its UI
#  follows the active Ghostty theme automatically.
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
export MANPAGER="sh -c 'col -bx | bat -l man -p'"  # render man pages with bat
export MANROFFOPT="-c"                              # required for correct bat output
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

# eza — modern ls replacement with icon and color support
alias l='eza --icons=always'
alias ls='eza --icons=always'
alias la='eza -al --icons=always'
alias ll='eza -l --icons=always'
alias lt='eza -a --tree --level=2 --icons=always'

# git shorthands
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

# infra
alias k='kubectl'


# =============================================================================
#  Plugins
# =============================================================================

# zsh-syntax-highlighting colorizes commands as you type: a recognized command
# turns colored, an unknown one stays red. It must be sourced after all bindkey
# calls because it wraps the zle widgets — sourcing it earlier breaks bindings.
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# =============================================================================
#  Git prompt (vcs_info)
# =============================================================================

setopt PROMPT_SUBST  # expand variables inside $PROMPT on every redraw

zstyle ':vcs_info:*'     enable git
zstyle ':vcs_info:git:*' check-for-changes true        # enable %u and %c markers
zstyle ':vcs_info:git:*' unstagedstr   ' %F{3}●%f'    # ● unstaged changes  (yellow)
zstyle ':vcs_info:git:*' stagedstr     ' %F{2}✚%f'    # ✚ staged changes    (green)
zstyle ':vcs_info:git:*' formats       ' %F{4} %b%u%c%f'
zstyle ':vcs_info:git:*' actionformats ' %F{4} %b %F{1}(%a)%u%c%f'
#                                                       ↑ (red) ongoing action (rebase/merge/…)

# Register vcs_info as a precmd hook so it runs before every prompt redraw.
# Using add-zsh-hook (instead of defining precmd() directly) is safe when
# multiple tools need the same hook — they are appended, not overwritten.
add-zsh-hook precmd vcs_info


# =============================================================================
#  Prompt
# =============================================================================

# All colors reference ANSI palette slots 0–15 so the prompt recolors itself
# automatically whenever the Ghostty theme changes — no config edit needed.
#
#   %K{0}  color0  — darkest background (usually matches the terminal bg)
#   %K{8}  color8  — bright-black, a slightly lighter dark shade
#   %K{7}  color7  — lightest block, used as background for the path segment
#   %F{15} color15 — bright white, high-contrast text on dark blocks
#   %F{0}  color0  — dark text on the light path block
#
# %D{%_I:%M%P} is a native zsh strftime expansion — no subprocess fork,
# updates correctly on every prompt redraw (unlike $(date ...)).
#
# \${vcs_info_msg_0_} is escaped so it expands at redraw time rather than
# at the moment PROMPT is assigned; without the backslash it would be empty.

NEWLINE=$'\n'
PROMPT="${NEWLINE}%K{0}%F{15} %D{%_I:%M%P} %K{8}%F{15} %n %K{7}%F{0} %~ %f%k\${vcs_info_msg_0_} ❯ "

# Welcome line — printed once at shell startup: time, uptime, kernel version.
# Standard ANSI base codes (30–37) are remapped when a color scheme loads,
# so these follow the terminal palette just like the prompt slots above:
#   \e[34m  color4 (blue)   → time
#   \e[32m  color2 (green)  → uptime
#   \e[33m  color3 (yellow) → kernel version
# print -P '%D{...}' is the correct zsh idiom for a formatted time string
# without forking a subprocess.
echo -e "${NEWLINE}\e[34m it's $(print -P '%D{%_I:%M%P}') \e[32m $(uptime -p | cut -c 4-) \e[33m $(uname -r) \e[0m"


# =============================================================================
#  Tools
# =============================================================================

# zoxide is a frecency-aware cd replacement: it learns your most-visited
# directories and lets you jump to them by typing just a fragment of the path.
# --cmd cd makes it a transparent drop-in so existing muscle memory still works.
eval "$(zoxide init --cmd cd zsh)"
