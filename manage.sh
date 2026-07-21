#!/usr/bin/env bash
# ============================================================
#  grub_custom-looks — manage.sh
#  A personal GRUB bootloader theme manager for Linux Mint
#  GitHub: https://github.com/YOUR_USERNAME/grub_custom-looks
#
#  Usage:
#    ./manage.sh              → Interactive menu
#    sudo ./manage.sh --apply → Apply config.cfg silently
#    ./manage.sh --list       → List all available options
#    ./manage.sh --download   → Download / update all theme repos
# ============================================================

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$SCRIPT_DIR/config.cfg"
REPO_NAME="grub_custom-looks"

# ── Colors ───────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

# ── Load config ──────────────────────────────────────────────
[[ ! -f "$CONFIG" ]] && { echo "config.cfg not found in $SCRIPT_DIR"; exit 1; }
source "$CONFIG"

# ── Helpers ──────────────────────────────────────────────────
info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERR]${NC}   $*"; exit 1; }

require_root() {
    if [[ "$EUID" -ne 0 ]]; then
        error "This action requires root. Run: sudo ./manage.sh $*"
    fi
}

# ── Theme registry ───────────────────────────────────────────
# Format: "Display Name|source_subfolder_in_themes/|install_type"
declare -A THEMES=(
    ["tela"]="Tela|grub2-themes|vinceliuice"
    ["vimix"]="Vimix|grub2-themes|vinceliuice"
    ["stylish"]="Stylish|grub2-themes|vinceliuice"
    ["whitesur"]="WhiteSur|grub2-themes|vinceliuice"
    ["catppuccin-mocha"]="Catppuccin Mocha|catppuccin|catppuccin"
    ["catppuccin-latte"]="Catppuccin Latte|catppuccin|catppuccin"
    ["catppuccin-frappe"]="Catppuccin Frappé|catppuccin|catppuccin"
    ["catppuccin-macchiato"]="Catppuccin Macchiato|catppuccin|catppuccin"
    ["darkmatter"]="Dark Matter|darkmatter|darkmatter"
    ["elegant-blur"]="Elegant Blur|elegant-grub2-themes|elegant"
    ["elegant-dark"]="Elegant Dark|elegant-grub2-themes|elegant"
    ["sleek-dark"]="Sleek Dark|sleek-themes|sleek"
    ["sleek-light"]="Sleek Light|sleek-themes|sleek"
    ["sleek-orange"]="Sleek Orange|sleek-themes|sleek"
)

# ── Repo URLs ────────────────────────────────────────────────
declare -A REPOS=(
    ["grub2-themes"]="https://github.com/vinceliuice/grub2-themes.git"
    ["catppuccin"]="https://github.com/catppuccin/grub.git"
    ["darkmatter"]="https://github.com/VandalByte/darkmatter-grub2-theme.git"
    ["elegant-grub2-themes"]="https://github.com/vinceliuice/Elegant-grub2-themes.git"
    ["sleek-themes"]="https://github.com/sandesh236/sleek--themes.git"
)

# ════════════════════════════════════════════════════════════
# LIST
# ════════════════════════════════════════════════════════════
cmd_list() {
    echo -e "\n${BOLD}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║  🎨  grub_custom-looks — Available Options   ║${NC}"
    echo -e "${BOLD}╚══════════════════════════════════════════════╝${NC}"

    echo -e "\n${BOLD}━━━ Themes ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${BOLD}Key (use in config.cfg)         Display Name         Status${NC}"
    for key in $(echo "${!THEMES[@]}" | tr ' ' '\n' | sort); do
        IFS='|' read -r name src type <<< "${THEMES[$key]}"
        local src_dir="$SCRIPT_DIR/themes/$src"
        local status
        [[ -d "$src_dir" ]] && status="${GREEN}✓ ready${NC}" || status="${YELLOW}⬇ run --download${NC}"
        printf "  %-32s %-22s %b\n" "$key" "$name" "$status"
    done

    echo -e "\n${BOLD}━━━ Wallpapers ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${CYAN}auto${NC}  → use the theme's own bundled wallpaper"
    find "$SCRIPT_DIR/wallpapers" -maxdepth 2 -type f \( -iname "*.jpg" -o -iname "*.png" \) 2>/dev/null \
        | sort | while read -r f; do
        echo "  $(basename "$f")  ($(du -h "$f" | cut -f1))"
    done

    echo -e "\n${BOLD}━━━ Icon Styles ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "  color      → Colorful OS icons"
    echo "  white      → White/monochrome OS icons"
    echo "  whitesur   → macOS-style icons"

    echo -e "\n${BOLD}━━━ Active Configuration (config.cfg) ━━━━━━━━━━━━━━━━━━━${NC}"
    echo "  Theme      : $ACTIVE_THEME"
    echo "  Wallpaper  : $ACTIVE_WALL"
    echo "  Icons      : $ACTIVE_ICONS"
    echo "  Theme Scale: $RESOLUTION"
    echo "  Display Res: ${GFXMODE:-1920x1080,auto}"
    echo ""
}

# ════════════════════════════════════════════════════════════
# DOWNLOAD
# ════════════════════════════════════════════════════════════
cmd_download() {
    mkdir -p "$SCRIPT_DIR/themes"

    # Symlink existing ~/grub2-themes if present and not already linked
    if [[ -d "$HOME/grub2-themes" && ! -e "$SCRIPT_DIR/themes/grub2-themes" ]]; then
        ln -sf "$HOME/grub2-themes" "$SCRIPT_DIR/themes/grub2-themes"
        info "Symlinked existing ~/grub2-themes → themes/grub2-themes"
    fi

    echo -e "\n${BOLD}Downloading / updating all theme repos...${NC}\n"
    for repo_name in "${!REPOS[@]}"; do
        local url="${REPOS[$repo_name]}"
        local dest="$SCRIPT_DIR/themes/$repo_name"

        # Skip grub2-themes if it's already a symlink
        [[ -L "$dest" ]] && { info "Skipping $repo_name (using existing symlink)"; continue; }

        if [[ -d "$dest/.git" ]]; then
            info "Updating $repo_name..."
            git -C "$dest" pull --quiet && success "$repo_name updated"
        else
            info "Cloning $repo_name..."
            git clone --depth=1 "$url" "$dest" --quiet && success "$repo_name downloaded"
        fi
    done
    echo ""
    success "All theme repos are ready. Run './manage.sh --list' to see them."
}

# ════════════════════════════════════════════════════════════
# INSTALLERS per theme type
# ════════════════════════════════════════════════════════════

install_vinceliuice() {
    local theme="$1" icons="$2" res="$3"
    local src="$SCRIPT_DIR/themes/grub2-themes"
    [[ ! -d "$src" ]] && error "grub2-themes not found. Run: ./manage.sh --download"
    info "Installing $theme (icons: $icons, res: $res)..."
    bash "$src/install.sh" -t "$theme" -i "$icons" -s "$res"
}

install_catppuccin() {
    local variant="$1"
    local src="$SCRIPT_DIR/themes/catppuccin"
    [[ ! -d "$src" ]] && error "Catppuccin not found. Run: ./manage.sh --download"
    local theme_dir="$src/src/catppuccin-${variant}-grub-theme"
    [[ ! -d "$theme_dir" ]] && error "Catppuccin variant '$variant' not found in repo"
    info "Installing Catppuccin $variant..."
    mkdir -p "$GRUB_THEMES_DIR/catppuccin-${variant}"
    cp -r "$theme_dir/." "$GRUB_THEMES_DIR/catppuccin-${variant}/"
    success "Catppuccin $variant installed"
}

install_darkmatter() {
    local src="$SCRIPT_DIR/themes/darkmatter"
    [[ ! -d "$src" ]] && error "Dark Matter not found. Run: ./manage.sh --download"
    info "Installing Dark Matter..."
    bash "$src/install.sh" -t "darkmatter"
    success "Dark Matter installed"
}

install_elegant() {
    local variant="$1"
    local src="$SCRIPT_DIR/themes/elegant-grub2-themes"
    [[ ! -d "$src" ]] && error "Elegant themes not found. Run: ./manage.sh --download"
    info "Installing Elegant $variant..."
    bash "$src/install.sh" -t "$variant" -s "$RESOLUTION"
    success "Elegant $variant installed"
}

install_sleek() {
    local variant="$1"
    local src="$SCRIPT_DIR/themes/sleek-themes"
    [[ ! -d "$src" ]] && error "Sleek themes not found. Run: ./manage.sh --download"
    local theme_dir
    case "$variant" in
        dark)   theme_dir="$src/Sleek theme-dark" ;;
        light)  theme_dir="$src/Sleek theme-light" ;;
        orange) theme_dir="$src/Sleek theme-orange" ;;
        *)      error "Unknown Sleek variant: $variant" ;;
    esac
    info "Installing Sleek $variant..."
    mkdir -p "$GRUB_THEMES_DIR/sleek-$variant"
    cp -r "$theme_dir/." "$GRUB_THEMES_DIR/sleek-$variant/"
    success "Sleek $variant installed to $GRUB_THEMES_DIR/sleek-$variant"
}

# ════════════════════════════════════════════════════════════
# WALLPAPER
# ════════════════════════════════════════════════════════════
apply_wallpaper() {
    local theme_install_name="$1"
    local theme_dir="$GRUB_THEMES_DIR/$theme_install_name"

    [[ "$ACTIVE_WALL" == "auto" ]] && { info "Using theme's bundled wallpaper"; return; }

    local wall_file=""
    if   [[ -f "$SCRIPT_DIR/wallpapers/$ACTIVE_WALL" ]];        then wall_file="$SCRIPT_DIR/wallpapers/$ACTIVE_WALL"
    elif [[ -f "$SCRIPT_DIR/wallpapers/custom/$ACTIVE_WALL" ]]; then wall_file="$SCRIPT_DIR/wallpapers/custom/$ACTIVE_WALL"
    elif [[ -f "$CUSTOM_WALL_PATH/$ACTIVE_WALL" ]];             then wall_file="$CUSTOM_WALL_PATH/$ACTIVE_WALL"
    elif [[ -f "$ACTIVE_WALL" ]];                               then wall_file="$ACTIVE_WALL"
    else warn "Wallpaper '$ACTIVE_WALL' not found — skipping"; return
    fi

    local bg_name
    bg_name=$(grep "desktop-image" "$theme_dir/theme.txt" 2>/dev/null \
              | grep -o '"[^"]*"' | tr -d '"' | head -1)
    bg_name="${bg_name:-background.jpg}"

    info "Applying wallpaper: $(basename "$wall_file") → $theme_dir/$bg_name"
    cp "$wall_file" "$theme_dir/$bg_name"
    success "Wallpaper applied"
}

# ════════════════════════════════════════════════════════════
# SET GRUB_THEME in /etc/default/grub
# ════════════════════════════════════════════════════════════
set_grub_theme() {
    local theme_path="$1"
    if grep -q "^GRUB_THEME=" "$GRUB_CONFIG"; then
        sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"$theme_path\"|" "$GRUB_CONFIG"
    else
        echo "GRUB_THEME=\"$theme_path\"" >> "$GRUB_CONFIG"
    fi
    success "GRUB_THEME set → $theme_path"
}

# ════════════════════════════════════════════════════════════
# APPLY
# ════════════════════════════════════════════════════════════
cmd_apply() {
    require_root
    local key="$ACTIVE_THEME"
    [[ -z "${THEMES[$key]+_}" ]] && error "Unknown theme: '$key'. Run './manage.sh --list' to see all options."

    IFS='|' read -r display_name src_folder install_type <<< "${THEMES[$key]}"
    
    # Auto-download if missing
    if [[ ! -d "$SCRIPT_DIR/themes/$src_folder" ]]; then
        info "Repo '$src_folder' is missing. Downloading it automatically..."
        local url="${REPOS[$src_folder]}"
        git clone --depth=1 "$url" "$SCRIPT_DIR/themes/$src_folder" --quiet || error "Failed to download $src_folder"
        success "Downloaded '$src_folder'"
    fi

    echo -e "\n${BOLD}Applying: $display_name${NC}\n"

    local installed_name=""

    case "$install_type" in
        vinceliuice)
            install_vinceliuice "$key" "$ACTIVE_ICONS" "$RESOLUTION"
            installed_name="$key"
            ;;
        catppuccin)
            local variant="${key#catppuccin-}"
            install_catppuccin "$variant"
            installed_name="catppuccin-$variant"
            ;;
        darkmatter)
            install_darkmatter
            installed_name="darkmatter"
            ;;
        elegant)
            local variant="${key#elegant-}"
            install_elegant "$variant"
            installed_name="Elegant-$variant"
            ;;
        sleek)
            local variant="${key#sleek-}"
            install_sleek "$variant"
            installed_name="sleek-$variant"
            ;;
        *)
            error "Unknown install type: $install_type"
            ;;
    esac

    apply_wallpaper "$installed_name"

    if [[ "$BUILD_ONLY" == true ]]; then
        info "Build-only mode: Skipping GRUB config update."
        echo ""
        echo -e "${BOLD}${GREEN}✓ Theme compiled!${NC} Your real GRUB config was NOT changed."
        echo -e "  Preview it safely by running: ${CYAN}grub2-theme-preview $GRUB_THEMES_DIR/$installed_name${NC}\n"
    else
        set_grub_theme "$GRUB_THEMES_DIR/$installed_name/theme.txt"

        if [[ -n "${GFXMODE:-}" ]]; then
            if grep -q "^#GRUB_GFXMODE=" "$GRUB_CONFIG"; then
                sed -i "s|^#GRUB_GFXMODE=.*|GRUB_GFXMODE=\"$GFXMODE\"|" "$GRUB_CONFIG"
            elif grep -q "^GRUB_GFXMODE=" "$GRUB_CONFIG"; then
                sed -i "s|^GRUB_GFXMODE=.*|GRUB_GFXMODE=\"$GFXMODE\"|" "$GRUB_CONFIG"
            else
                echo "GRUB_GFXMODE=\"$GFXMODE\"" >> "$GRUB_CONFIG"
            fi
            success "Display Resolution set → $GFXMODE"
        fi

        info "Rebuilding GRUB config..."
        update-grub

        echo ""
        echo -e "${BOLD}${GREEN}✓ Done!${NC} Theme '${BOLD}$display_name${NC}' is now active."
        echo -e "  Reboot to see your new GRUB look.\n"
    fi
}

# ════════════════════════════════════════════════════════════
# INTERACTIVE MENU
# ════════════════════════════════════════════════════════════
cmd_interactive() {
    echo -e "\n${BOLD}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║  🎨  grub_custom-looks                       ║${NC}"
    echo -e "${BOLD}║  GRUB Theme Manager for Linux Mint           ║${NC}"
    echo -e "${BOLD}╚══════════════════════════════════════════════╝${NC}\n"
    echo "  1)  List all themes, wallpapers, icons & current config"
    echo "  2)  Download / update all theme repos"
    echo "  3)  Apply current config.cfg settings"
    echo "  4)  Quick-switch theme interactively"
    echo "  5)  Change wallpaper"
    echo "  6)  Change icon style"
    echo "  7)  Exit"
    echo ""
    read -rp "  Choose [1-7]: " choice

    case "$choice" in
        1) cmd_list ;;
        2) cmd_download ;;
        3) cmd_apply ;;

        4)
            require_root
            echo -e "\n${BOLD}Available themes:${NC}"
            local i=1
            local -a theme_keys
            for key in $(echo "${!THEMES[@]}" | tr ' ' '\n' | sort); do
                IFS='|' read -r name _ _ <<< "${THEMES[$key]}"
                printf "  %2d) %-25s %s\n" "$i" "$name" "($key)"
                theme_keys[$i]="$key"
                ((i++))
            done
            echo ""
            read -rp "  Select theme [1-$((i-1))]: " theme_idx
            
            if [[ -n "$theme_idx" && "$theme_idx" =~ ^[0-9]+$ && "$theme_idx" -ge 1 && "$theme_idx" -lt $i ]]; then
                new_theme="${theme_keys[$theme_idx]}"
            else
                new_theme="$ACTIVE_THEME"
                warn "Keeping current theme: '$new_theme'"
            fi
            
            read -rp "  Customize icons, wallpaper, and font size? (y/N): " customize
            if [[ "$customize" =~ ^[Yy]$ ]]; then
                echo -e "\n  Icon styles:"
                echo "    1) color"
                echo "    2) white"
                echo "    3) whitesur"
                read -rp "  Select icon style [1-3]: " icon_idx
                case "$icon_idx" in
                    1) new_icons="color" ;;
                    2) new_icons="white" ;;
                    3) new_icons="whitesur" ;;
                    *) new_icons="$ACTIVE_ICONS" ;;
                esac
                
                echo -e "\n  Display Resolution (sets both monitor output and theme scaling):"
                echo "    1) 1080p        (1920x1080)"
                echo "    2) 2k           (2560x1440)"
                echo "    3) 4k           (3840x2160)"
                echo "    4) ultrawide    (2560x1080)"
                echo "    5) ultrawide2k  (3440x1440)"
                read -rp "  Select Display Resolution [1-5]: " res_choice
                
                case "$res_choice" in
                    1) new_res="1080p"; new_gfx="1920x1080,auto" ;;
                    2) new_res="2k"; new_gfx="2560x1440,auto" ;;
                    3) new_res="4k"; new_gfx="3840x2160,auto" ;;
                    4) new_res="ultrawide"; new_gfx="2560x1080,auto" ;;
                    5) new_res="ultrawide2k"; new_gfx="3440x1440,auto" ;;
                    *) new_res="$RESOLUTION"; new_gfx="${GFXMODE:-1920x1080,auto}" ;;
                esac
                
                echo -e "\n  Available wallpapers:"
                echo "    1) auto (theme's default)"
                local w=2
                local -a wall_files
                wall_files[1]="auto"
                while read -r f; do
                    local fname=$(basename "$f")
                    echo "    $w) $fname"
                    wall_files[$w]="$fname"
                    ((w++))
                done < <(find "$SCRIPT_DIR/wallpapers" -maxdepth 2 -type f \( -iname "*.jpg" -o -iname "*.png" \) 2>/dev/null | sort)
                
                read -rp "  Select wallpaper [1-$((w-1))]: " wall_idx
                if [[ -n "$wall_idx" && "$wall_idx" =~ ^[0-9]+$ && "$wall_idx" -ge 1 && "$wall_idx" -lt $w ]]; then
                    new_wall="${wall_files[$wall_idx]}"
                else
                    new_wall="$ACTIVE_WALL"
                fi
            else
                new_icons="$ACTIVE_ICONS"
                new_res="$RESOLUTION"
                new_gfx="${GFXMODE:-1920x1080,auto}"
                new_wall="auto"
            fi
            
            sed -i "s|^ACTIVE_THEME=.*|ACTIVE_THEME=\"$new_theme\"|" "$CONFIG"
            sed -i "s|^ACTIVE_ICONS=.*|ACTIVE_ICONS=\"$new_icons\"|" "$CONFIG"
            sed -i "s|^RESOLUTION=.*|RESOLUTION=\"$new_res\"|" "$CONFIG"
            sed -i "s|^ACTIVE_WALL=.*|ACTIVE_WALL=\"$new_wall\"|" "$CONFIG"
            if grep -q "^GFXMODE=" "$CONFIG"; then
                sed -i "s|^GFXMODE=.*|GFXMODE=\"$new_gfx\"|" "$CONFIG"
            else
                echo "GFXMODE=\"$new_gfx\"" >> "$CONFIG"
            fi
            source "$CONFIG"
            
            echo -e "\n  Do you want to APPLY to real GRUB or just BUILD for live preview?"
            echo "    1) Apply to real GRUB"
            echo "    2) Build only (Safe Preview)"
            read -rp "  Choice [1/2]: " build_choice
            
            if [[ "$build_choice" == "2" ]]; then
                BUILD_ONLY=true
            else
                BUILD_ONLY=false
            fi
            
            cmd_apply
            ;;

        5)
            require_root
            echo -e "\n${BOLD}Available wallpapers:${NC}"
            echo "  auto  → theme's bundled wallpaper"
            find "$SCRIPT_DIR/wallpapers" -maxdepth 2 -type f \( -iname "*.jpg" -o -iname "*.png" \) \
                | sort | while read -r f; do echo "  $(basename "$f")"; done
            echo ""
            echo "  To add your own: copy a 1080p JPG/PNG to wallpapers/custom/"
            echo ""
            read -rp "  Enter wallpaper filename (or 'auto'): " new_wall
            sed -i "s|^ACTIVE_WALL=.*|ACTIVE_WALL=\"$new_wall\"|" "$CONFIG"
            source "$CONFIG"
            cmd_apply
            ;;

        6)
            require_root
            echo -e "\n  Icon styles: color | white | whitesur"
            read -rp "  Icon style [$ACTIVE_ICONS]: " new_icons
            new_icons="${new_icons:-$ACTIVE_ICONS}"
            sed -i "s|^ACTIVE_ICONS=.*|ACTIVE_ICONS=\"$new_icons\"|" "$CONFIG"
            source "$CONFIG"
            cmd_apply
            ;;

        7) exit 0 ;;
        *) warn "Invalid choice" ;;
    esac
}

# ════════════════════════════════════════════════════════════
# ENTRY POINT
# ════════════════════════════════════════════════════════════

# Ensure folders exist
mkdir -p "$SCRIPT_DIR/themes" \
         "$SCRIPT_DIR/wallpapers/custom" \
         "$SCRIPT_DIR/icons/custom"

# Auto-symlink existing ~/grub2-themes on first run
if [[ -d "$HOME/grub2-themes" && ! -e "$SCRIPT_DIR/themes/grub2-themes" ]]; then
    ln -sf "$HOME/grub2-themes" "$SCRIPT_DIR/themes/grub2-themes"
fi

BUILD_ONLY=false

case "${1:-}" in
    --apply)      cmd_apply ;;
    --build-only) BUILD_ONLY=true; cmd_apply ;;
    --list)       cmd_list ;;
    --download)   cmd_download ;;
    --help|-h)
        echo ""
        echo "  Usage: sudo ./manage.sh [option]"
        echo ""
        echo "  Options:"
        echo "    (none)         Interactive menu"
        echo "    --apply        Apply config.cfg settings and rebuild GRUB"
        echo "    --build-only   Compile theme but do NOT rebuild GRUB (for safe previewing)"
        echo "    --list         List all available themes, wallpapers, icons"
        echo "    --download     Download / update all theme repos"
        echo "    --help         Show this help"
        echo ""
        ;;
    *)            cmd_interactive ;;
esac
