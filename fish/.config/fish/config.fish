# -----------------------------------------------------
# Exports
# -----------------------------------------------------
set -gx EDITOR nvim
set -gx MANPAGER "nvim +Man!"

# -----------------------------------------------------
# Configuration
# -----------------------------------------------------
if status is-interactive

    # --- Prompt ---
    starship init fish | source

    # --- Aliases ---
    alias c="clear"
    alias ls="eza --icons=always"
    alias la="eza -al --icons=always"
    alias ll="eza -l --icons=always"
    alias v="$EDITOR"
    alias k="kubectl"
    alias cat="bat" 

    # --- System ---
    alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

    # --- Autostart ---
    fastfetch

end