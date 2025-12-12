# -----------------------------------------------------
# Exports
# -----------------------------------------------------
set -gx EDITOR nvim
set -gx MANPAGER "nvim +Man!"
set -U fish_greeting ""
# fish_add_path ~/.local/bin

# -----------------------------------------------------
# Configuration
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
    alias cat="bat --style=plain"

    # --- System ---
    alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

    # --- Autostart ---
    fastfetch

end

