#!/usr/bin/env bash
# ============================================================================
# Hyprland Dotfiles Installer
# ============================================================================
# What this does:
#   1. Installs GNU Stow (if missing)
#   2. Symlinks all configs into ~/ using stow
#   3. Creates ~/Pictures/Wallpapers, ~/Pictures/Screenshots, ~/.bashrc.d
#   4. Fixes nemo bookmarks to match current username
#   5. Installs kitty theme if missing
#   6. Optionally copies wallpapers from source machine
#   7. Optionally installs packages from packages.txt
#   8. Optionally installs Sober (VRChat flatpak)
#   9. Optionally installs AUR packages (hyprlauncher)
#
# Packages installed: hyprland, waybar, wofi, kitty, swaync, swww, wlogout,
#   grim, slurp, cliphist, pipewire, playerctl, nemo, and more (see packages.txt)
# ============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
STOW_PACKAGES=(hypr waybar wofi kitty alacritty swaync colors scripts portal gtk3 gtk4 icons gtkrc shell)

info()  { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
ok()    { printf "\033[1;32m[OK]\033[0m   %s\n" "$*"; }
warn()  { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
err()   { printf "\033[1;31m[ERR]\033[0m  %s\n" "$*" >&2; }

echo "=========================================="
echo " Hyprland Dotfiles Bootstrap"
echo "=========================================="
echo ""

# --- Check for stow ---
if ! command -v stow &>/dev/null; then
    warn "GNU Stow is not installed."
    if command -v pacman &>/dev/null; then
        info "Installing stow via pacman..."
        sudo pacman -S --noconfirm stow
    elif command -v apt &>/dev/null; then
        info "Installing stow via apt..."
        sudo apt install -y stow
    elif command -v dnf &>/dev/null; then
        info "Installing stow via dnf..."
        sudo dnf install -y stow
    else
        err "Unknown package manager. Install GNU Stow manually."
        exit 1
    fi
fi

# --- Stow packages ---
# If files already exist (re-running on existing machine), use --adopt
STOW_OPTS=()
for pkg in "${STOW_PACKAGES[@]}"; do
    pkgdir="$DOTFILES_DIR/$pkg"
    if [ ! -d "$pkgdir" ]; then
        warn "Package $pkg not found, skipping."
        continue
    fi
    # Check if any target file already exists and is not a symlink
    while IFS= read -r -d '' f; do
        rel="${f#$pkgdir/}"
        target="$HOME/$rel"
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            STOW_OPTS=(--adopt)
            break 2
        fi
    done < <(find "$pkgdir" -type f -print0)
done

for pkg in "${STOW_PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
        info "Stowing $pkg..."
        stow -d "$DOTFILES_DIR" -t "$HOME" "${STOW_OPTS[@]}" "$pkg"
        ok "Stowed $pkg"
    fi
done

if [ "${#STOW_OPTS[@]}" -gt 0 ]; then
    info "Used --adopt: existing files were moved into the dotfiles repo and symlinked."
    info "Check 'git diff' in ~/dotfiles to see what changed."
fi

# --- Create directories ---
mkdir -p "$HOME/Pictures/Wallpapers"
mkdir -p "$HOME/Pictures/Screenshots"
mkdir -p "$HOME/.bashrc.d"

# --- Fix nemo bookmarks for current user ---
BMFILE="$HOME/.config/gtk-3.0/bookmarks"
if [ -f "$BMFILE" ]; then
    sed -i "s|/home/omnipathic/|$HOME/|g" "$BMFILE"
    ok "Fixed nemo bookmarks paths for current user"
fi

# --- Fix hyprpaper paths for current user ---
HPFILE="$HOME/.config/hypr/hyprpaper.conf"
if [ -f "$HPFILE" ]; then
    sed -i "s|/home/omnipathic/|$HOME/|g" "$HPFILE"
    ok "Fixed hyprpaper wallpaper paths for current user"
fi

# --- Kitty theme setup ---
KITTY_THEME_DIR="$HOME/.config/kitty"
if [ ! -f "$KITTY_THEME_DIR/GruvBox_DarkHard.conf" ]; then
    info "Kitty GruvBox_DarkHard theme not found. Attempting to install..."
    # Try downloading from kitty-themes repo
    if command -v curl &>/dev/null; then
        mkdir -p "$KITTY_THEME_DIR"
        curl -sfL "https://raw.githubusercontent.com/dexpota/kitty-themes/master/themes/Gruvbox%20Dark%20Hard.conf" \
            -o "$KITTY_THEME_DIR/GruvBox_DarkHard.conf" 2>/dev/null && \
            ok "Downloaded kitty GruvBox_DarkHard theme" || \
            warn "Could not download kitty theme. Run 'kitty +kitten themes' manually."
    fi
fi

# --- Copy wallpapers if available ---
if [ -d "$DOTFILES_DIR/wallpapers" ] && [ "$(ls -A "$DOTFILES_DIR/wallpapers" 2>/dev/null)" ]; then
    info "Copying wallpapers from dotfiles..."
    cp -n "$DOTFILES_DIR/wallpapers"/* "$HOME/Pictures/Wallpapers/" 2>/dev/null && \
        ok "Wallpapers copied" || \
        warn "No wallpapers found in dotfiles/wallpapers/"
else
    warn "No wallpapers in dotfiles. Put wallpapers in ~/Pictures/Wallpapers/"
    warn "Then update paths in ~/.config/hypr/hyprpaper.conf"
fi

# --- Package install (optional) ---
if command -v pacman &>/dev/null; then
    echo ""
    info "Arch Linux detected."
    echo "  packages.txt contains all needed packages including:"
    echo "    hyprland, waybar, wofi, kitty, swaync, swww, wlogout,"
    echo "    grim, slurp, cliphist, pipewire, playerctl, nemo, fonts, etc."
    read -rp "Install packages from packages.txt? [y/N] " yn
    if [[ "$yn" =~ ^[Yy]$ ]]; then
        PKG_FILE="$DOTFILES_DIR/packages.txt"
        if [ -f "$PKG_FILE" ]; then
            info "Installing packages (skipping already installed)..."
            sudo pacman -S --needed --noconfirm $(grep -v '^#' "$PKG_FILE" | grep -v '^$' | tr '\n' ' ')
            ok "Packages installed"
        fi
    fi

    # --- AUR packages ---
    echo ""
    info "AUR packages needed (not in official repos):"
    echo "  - hyprlauncher  (SUPER+R app launcher)"
    if command -v paru &>/dev/null; then
        read -rp "Install AUR packages with paru? [y/N] " yn
        if [[ "$yn" =~ ^[Yy]$ ]]; then
            paru -S --needed --noconfirm hyprlauncher
            ok "AUR packages installed"
        fi
    elif command -v yay &>/dev/null; then
        read -rp "Install AUR packages with yay? [y/N] " yn
        if [[ "$yn" =~ ^[Yy]$ ]]; then
            yay -S --needed --noconfirm hyprlauncher
            ok "AUR packages installed"
        fi
    else
        warn "No AUR helper found. Install hyprlauncher manually:"
        warn "  git clone https://aur.archlinux.org/hyprlauncher.git && cd hyprlauncher && makepkg -si"
    fi

    # --- Sober (VRChat) flatpak ---
    echo ""
    read -rp "Install Sober (VRChat flatpak)? [y/N] " yn
    if [[ "$yn" =~ ^[Yy]$ ]]; then
        if command -v flatpak &>/dev/null; then
            flatpak install -y flathub org.vinegarhq.Sober
            ok "Sober installed"
        else
            warn "flatpak not installed. Install it first: sudo pacman -S flatpak"
        fi
    fi
fi

echo ""
echo "=========================================="
info "To finish:"
info "  1. Edit ~/.config/hypr/hyprland.conf  -> set your monitor(s)"
info "  2. Copy wallpapers to ~/Pictures/Wallpapers/ (if not done)"
info "  3. Put machine-specific aliases in ~/.bashrc.d/"
info "  4. Restart Hyprland or run: hyprctl reload"
echo "=========================================="
ok "Done!"
