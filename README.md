# Hyprland Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/) — each directory is a self-contained package that gets symlinked into `~/`.

![Desktop](https://i.imgur.com/placeholder.png) <!-- add a screenshot -->

## Packages

| Stow package | What it configures |
|---|---|
| `hypr/` | Hyprland, hyprpaper, xdg-desktop-portal |
| `waybar/` | Status bar (workspaces, clock, audio, bluetooth, power) |
| `wofi/` | Application launcher |
| `kitty/` | Terminal emulator |
| `alacritty/` | Alternative terminal |
| `swaync/` | Notification center & control panel |
| `colors/` | Shared color variables for waybar |
| `scripts/` | Wallpaper random/select/toggle scripts |
| `portal/` | xdg-desktop-portal-hyprland config |
| `gtk3/` | GTK3 theme (Breeze-Dark) + window button SVGs + nemo bookmarks |
| `gtk4/` | GTK4 theme (Breeze-Dark) |
| `icons/` | GoogleDot-White cursor theme |
| `gtkrc/` | GTK2 config |
| `shell/` | `.bashrc` |

## Quick Start

```bash
git clone https://github.com/Omnipathic/dotfiles-from-omnipathic ~/dotfiles
cd ~/dotfiles
./install.sh
```

## What `install.sh` Does

1. Installs **stow** if missing
2. Symlinks all 14 config packages into `~/`
3. Creates `~/Pictures/Wallpapers`, `~/Pictures/Screenshots`, `~/.bashrc.d`
4. Fixes nemo bookmarks & hyprpaper paths to match your username
5. Downloads the **GruvBox Dark Hard** theme for kitty
6. Copies wallpapers from `dotfiles/wallpapers/` → `~/Pictures/Wallpapers/`
7. Prompts to install **~60 packages** (hyprland, waybar, wofi, kitty, swaync, swww, grim, slurp, pipewire, etc.)
8. Prompts to install **hyprlauncher** (AUR)
9. Prompts to install **Sober** (VRChat flatpak)

## Selective Stow

```bash
cd ~/dotfiles
stow hypr           # Hyprland only
stow waybar         # Waybar only
stow -D waybar      # Remove waybar symlinks
```

## Keybinds (Hyprland)

| Key | Action |
|---|---|
| `SUPER + SPACE` | App launcher (wofi) |
| `SUPER + RETURN` | App launcher (hyprlauncher) |
| `SUPER + Q` | Kill active window |
| `SUPER + F` | Firefox |
| `SUPER + S` | Spotify |
| `SUPER + D` | Discord |
| `SUPER + E` | File manager (nemo) |
| `SUPER + V` | Clipboard history (cliphist + wofi) |
| `SUPER + SHIFT + S` | Screenshot region (grim + slurp) |
| `SUPER + SHIFT + O` | OBS replay buffer |
| `CTRL + ALT + T` | Kitty terminal |
| `XF86Audio*` | Volume/media keys (pipewire + playerctl) |

## Post-Install

1. **Monitors** — edit `~/.config/hypr/hyprland.conf` and set your displays:
   ```
   monitor = eDP-1,1920x1080@60,0x0,1
   ```
2. **Wallpapers** — put images in `~/Pictures/Wallpapers/` (or edit the path in `hyprpaper.conf`)
3. **Machine-specific aliases** — add them to `~/.bashrc.d/`, they're sourced automatically
4. **Restart** — `hyprctl reload` or log out & back in

## Packages Installed

From `packages.txt`:

```
hyprland  hyprpaper  waybar  wofi  kitty  swaync
swww  wlogout  grim  slurp  cliphist  wl-clipboard
pipewire  wireplumber  playerctl  pavucontrol  blueman
nemo  firefox  spotify-launcher  discord  obs-studio
ttf-jetbrains-mono-nerd  ttf-sourcecodepro-nerd
breeze  breeze-gtk  breeze-icons  google-cursor
fortune-mod  cowsay  lolcat
polkit-gnome  nm-connection-editor  xdg-desktop-portal-*
```

AUR: `hyprlauncher`

## Credits

- **Cursor:** GoogleDot-White
- **GTK Theme:** Breeze-Dark
- **Fonts:** JetBrains Mono Nerd Font, SauceCodePro Nerd Font, Noto Sans
- **Icons:** Breeze-dark
