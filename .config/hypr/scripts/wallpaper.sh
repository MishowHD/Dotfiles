#!/bin/bash
WALLPAPER_DIR="$HOME/wallpaper/"
LAST_WALL="$HOME/.cache/wal/wal"

# ── Choose wal ──────────────────────────────────────────────────────────

if [[ -n "$1" ]]; then
  WALLPAPER="$1"
else
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
    sort |
    while IFS= read -r file; do
      echo "$file"$'\t'"$(basename "$file")"
    done |
    rofi -dmenu \
      -p " Wallpaper" \
      -i \
      -theme ~/.config/rofi/launchers/type-2/style-menu.rasi \
      -display-columns 2 \
      -format 's' |
    cut -f1)
fi

[[ -z "$WALLPAPER" ]] && {
  echo "No wal chosen"
  exit 0
}
[[ ! -f "$WALLPAPER" ]] && {
  echo "File not found: $WALLPAPER"
  exit 1
}

echo "→ Wallpaper: $WALLPAPER"

# ── swww ───────────────────────────────────────────────────

swww img "$WALLPAPER" \
  --transition-type fade

# ── pywal ───────────────────────────────────────────────────

wal -i "$WALLPAPER" -q

echo "→ Generated colors"

# ── swaync ───────────────────────────────────────────────────────────

pkill swaync 2>/dev/null
swaync &
echo "→ Swaync reloaded"

echo "✓ Teme set!"
