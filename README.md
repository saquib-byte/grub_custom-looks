# GRUB Custom Looks

This repository allows you to easily download and manage multiple awesome GRUB themes for your Linux system. Instead of using a custom wrapper, you can fetch the original repositories directly and use their native installation methods for the best compatibility and customization options.

## Getting Started

1. **Download / Update Themes**
   Run the downloader script to fetch the configured repositories into the `themes/` folder:
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
- **Details:** The interactive Python installer will launch in your terminal. It will ask you to type the number corresponding to your desired OS style, resolution, and icon set, and will apply it directly to GRUB.

### 2. Elegant Themes
A modular theme engine featuring multiple layouts (window, float, blur, sharp) and styles.
- **Path:** `themes/elegant/`
- **Installation:**
  ```bash
  cd themes/elegant
  sudo ./install.sh
  ```
- **Details:** Running the script without arguments will launch an interactive graphical wizard right in your terminal, allowing you to select your preferred background, layout style, side, and resolution. 
  
  Alternatively, you can skip the wizard and use flags:
  ```bash
  sudo ./install.sh -t forest -p blur -s 1080p
  ```
  Run `./install.sh -h` to see all available customization flags.

### 3. Gorgeous-GRUB (Reference Catalog)
- **Path:** `themes/Gorgeous-GRUB-reference/`
- **Details:** This is a curated showcase/index of many community themes (e.g., Minecraft, Persona 5, Cyberpunk). It does not contain an installer itself. Use it as a catalog to discover new themes, then download and install them manually following their respective instructions.
