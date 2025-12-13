# -----------------------------------------------------
# Environment / Exports
# -----------------------------------------------------

# Editor
set -Ux EDITOR nvim

# Pager
set -Ux PAGER bat

# Manpager
set -Ux MANPAGER "bat -p -l man"

# Disable fish greeting
set -U fish_greeting ""

# -----------------------------------------------------
# Interactive configuration
# -----------------------------------------------------
if status is-interactive

    # --- Prompt ---
    starship init fish | source
    # oh-my-posh init fish --config ~/.config/ohmyposh/zen.toml | source

    # --- Aliases ---
    alias c="clear"
    alias ls="eza --icons=always"
    alias la="eza -al --icons=always"
    alias ll="eza -l --icons=always"
    alias v="$EDITOR"
    alias k="kubectl"

    # cat → bat
    alias cat="bat --style=plain"

    # --- System ---
    alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

    # --- Autostart ---
    fastfetch

end
