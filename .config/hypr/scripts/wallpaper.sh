#!/bin/bash
WALLPAPER_DIR="$HOME/wallpaper/"
LAST_WALL="$HOME/.cache/wal/wal"

# ── Choose wal ──────────────────────────────────────────────────────────

if [[ -n "$1" ]]; then
  WALLPAPER="$1"
else
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
    sort |
    rofi -dmenu \
      -p " Wallpaper" \
      -i \
      -theme ~/.config/rofi/launchers/type-2/style-menu.rasi \
      -format 's')
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

# ── Imposta sfondo con swww ───────────────────────────────────────────────────

swww img "$WALLPAPER" \
  --transition-type fade \
  --transition-duration 1.5 \
  --transition-fps 60

# ── Genera colori con pywal ───────────────────────────────────────────────────

wal -i "$WALLPAPER" -q #  -q = silenzioso

echo "→ Generated colors"

# ── Ricarica swaync ───────────────────────────────────────────────────────────

pkill swaync 2>/dev/null
swaync &
echo "→ Swaync reloaded"

echo "✓ Teme set!"
