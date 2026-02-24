#!/bin/bash

WALLPAPER_DIR="$HOME/wallpaper/"

WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
  sort |
  while IFS= read -r f; do echo "$f"$'\t'"$(basename "$f")"; done |
  rofi -dmenu \
    -p " Wallpaper" \
    -i \
    -theme ~/.config/rofi/launchers/type-2/style-menu.rasi \
    -display-columns 2 \
    -format 's' |
  cut -f1)

[[ -z "$WALLPAPER" ]] && exit 0
[[ ! -f "$WALLPAPER" ]] && exit 1

wal -i "$WALLPAPER" -q -n
swww img "$WALLPAPER" --transition-type grow --transition-duration 0.5 --transition-fps 60
swaync-client -rs
