#!/usr/bin/env bash

wallpapers_dir="$HOME/Pictures/Wallpapers"

random_wallpaper=$(find "$wallpapers_dir" -maxdepth 1 -type f | shuf -n 1)

echo "$random_wallpaper" > ~/.wallpaper
swww img "$random_wallpaper" --transition-type any --transition-duration 2
