#!/usr/bin/env bash

if pidof wofi > /dev/null; then
    pkill wofi
fi

wallpapers_dir="$HOME/Pictures/Wallpapers"

selected_wallpaper=$(for a in "$wallpapers_dir"/*; do
    echo -en "$(basename "${a%.*}")\0icon\x1f$a\n"
done | wofi --dmenu)

image_fullname_path=$(find "$wallpapers_dir" -type f -name "$selected_wallpaper.*" | head -n 1)

echo "$image_fullname_path" > ~/.wallpaper
swww img "$image_fullname_path" --transition-type any --transition-duration 2
