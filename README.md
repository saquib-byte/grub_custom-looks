# GRUB Custom Looks

This repository allows you to easily download and manage multiple awesome GRUB themes for your Linux system. Instead of using a custom wrapper, you can fetch the original repositories directly and use their native installation methods for the best compatibility and customization options.

## Getting Started

1. **Download / Update Themes**
   Run the downloader script to fetch all configured repositories into the `themes/` folder:
   ```bash
   chmod +x get-themes.sh
   ./get-themes.sh
   ```
   *Note: You can run this script again at any time to pull the latest updates for all themes.*

## How to Install Themes

Once downloaded, navigate into the `themes/` directory and use the official installers provided by each theme's author. 

### 1. Dark Matter
A highly customizable, sci-fi inspired theme with 47 OS-specific variants.
- **Path:** `themes/darkmatter/`
- **Installation:**
  ```bash
  cd themes/darkmatter
  sudo python3 darkmatter-theme.py -i
  ```
- **Details:** The interactive Python installer will ask you to choose your OS style, resolution, and icon set.

### 2. Elegant Themes
A modular theme engine featuring multiple layouts (window, float, blur, sharp) and styles.
- **Path:** `themes/elegant/`
- **Installation:**
  ```bash
  cd themes/elegant
  sudo ./install.sh
  ```
- **Details:** Running the script without arguments will launch a TUI wizard. You can also use flags (e.g., `sudo ./install.sh -t forest -p blur -s 1080p`). Run `./install.sh -h` to see all options.

### 3. Vinceliuice GRUB2 Themes (Tela, Vimix, Stylish, WhiteSur)
A collection of sleek, modern themes.
- **Path:** `themes/grub2-themes/`
- **Installation:**
  ```bash
  cd themes/grub2-themes
  sudo ./install.sh -b -t whitesur  # Example: Install WhiteSur
  ```
- **Details:** Check the repo's README for available theme names and icon options.

### 4. Sleek Themes
Minimalist themes available in Dark, Light, and Orange variants.
- **Path:** `themes/sleek/`
- **Installation:**
  Sleek themes do not come with an installer script. You can manually copy the theme folder to your GRUB themes directory and edit `/etc/default/grub`.
  ```bash
  sudo cp -r "themes/sleek/Sleek theme-dark" /boot/grub/themes/
  # Then set GRUB_THEME="/boot/grub/themes/Sleek theme-dark/theme.txt" in /etc/default/grub
  # Finally run: sudo update-grub
  ```

### 5. Catppuccin
Soothing pastel themes based on the Catppuccin palette.
- **Path:** `themes/catppuccin/`
- **Installation:**
  ```bash
  cd themes/catppuccin
  sudo ./install.sh mocha  # Or latte, frappe, macchiato
  ```

### 6. Gorgeous-GRUB (Reference Catalog)
- **Path:** `themes/Gorgeous-GRUB-reference/`
- **Details:** This is a curated showcase/index of many community themes (e.g., Minecraft, Persona 5, Cyberpunk). It does not contain an installer itself. Use it as a catalog to discover new themes, then download and install them manually following their respective instructions.
