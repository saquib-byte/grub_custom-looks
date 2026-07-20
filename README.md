# grub_custom-looks

> **A personal GRUB bootloader theme manager for Linux Mint (and Ubuntu-based distros).**  
> Easily download, switch, and apply themes, wallpapers, and icon packs — with a single interactive command. No manual file copying required.

---

## ✨ Features

- 🎨 **10+ curated themes** from top GitHub creators (Tela, Vimix, Catppuccin, Dark Matter, Elegant, Sleek, and more)
- 🖼️ **Wallpaper switcher** — use bundled theme walls or drop in any of your own images
- 🔷 **Icon style switcher** — color, white, or macOS-style icon packs
- 📦 **One-command downloader** — clones all theme repos automatically
- ⚡ **One-command applier** — installs the theme, sets wallpaper, and runs `update-grub` in one shot
- 📝 **Simple config file** — change everything by editing one plain text file
- 🔄 **Easy updates** — `git pull` in any theme folder to get the latest version

---

## 📁 Folder Structure

```
grub_custom-looks/
├── README.md               ← This file
├── manage.sh               ← Main manager script (run this!)
├── config.cfg              ← Your active configuration (edit this to switch themes)
├── .gitignore
│
├── themes/                 ← Theme repos live here (auto-downloaded or manually added)
│   ├── grub2-themes/       ← symlinked to ~/grub2-themes if already installed
│   ├── catppuccin/
│   ├── darkmatter/
│   ├── elegant-grub2-themes/
│   └── sleek-themes/
│
├── wallpapers/             ← Your personal GRUB wallpapers (1080p recommended)
│   ├── tela.jpg
│   ├── vimix.jpg
│   ├── stylish.jpg
│   ├── whitesur.jpg
│   └── custom/             ← Drop YOUR OWN images here
│
└── icons/
    └── custom/             ← Drop your own OS icons (.png) here
```

---

## 🚀 Quick Start

### 1. Clone this repo
```bash
git clone https://github.com/YOUR_USERNAME/grub_custom-looks.git ~/grub_custom-looks
cd ~/grub_custom-looks
chmod +x manage.sh
```

### 2. Download all themes
```bash
./manage.sh --download
```
This clones all supported theme repos into the `themes/` folder.

### 3. See what is available
```bash
./manage.sh --list
```

### 4. Apply a theme (interactive)
```bash
sudo ./manage.sh
```
Pick option **4** to switch theme interactively, or option **3** to apply your current `config.cfg`.

---

## ⚙️ Configuration (`config.cfg`)

Open [`config.cfg`](config.cfg) in any text editor and set your preferences:

```bash
ACTIVE_THEME="tela"        # which theme to use
ACTIVE_WALL="auto"         # "auto" = theme default, or a filename from wallpapers/
ACTIVE_ICONS="color"       # color | white | whitesur
RESOLUTION="1080p"         # 1080p | 2k | 4k | ultrawide | ultrawide2k
```

Then apply:
```bash
sudo ./manage.sh --apply
```

---

## 🎨 Available Themes

| Key (use in config.cfg) | Display Name | Source |
|---|---|---|
| `tela` | Tela | [vinceliuice/grub2-themes](https://github.com/vinceliuice/grub2-themes) |
| `vimix` | Vimix | [vinceliuice/grub2-themes](https://github.com/vinceliuice/grub2-themes) |
| `stylish` | Stylish | [vinceliuice/grub2-themes](https://github.com/vinceliuice/grub2-themes) |
| `whitesur` | WhiteSur | [vinceliuice/grub2-themes](https://github.com/vinceliuice/grub2-themes) |
| `catppuccin-mocha` | Catppuccin Mocha | [catppuccin/grub](https://github.com/catppuccin/grub) |
| `catppuccin-latte` | Catppuccin Latte | [catppuccin/grub](https://github.com/catppuccin/grub) |
| `catppuccin-frappe` | Catppuccin Frappé | [catppuccin/grub](https://github.com/catppuccin/grub) |
| `catppuccin-macchiato` | Catppuccin Macchiato | [catppuccin/grub](https://github.com/catppuccin/grub) |
| `darkmatter` | Dark Matter | [VandalByte/darkmatter-grub2-theme](https://github.com/VandalByte/darkmatter-grub2-theme) |
| `elegant-blur` | Elegant Blur | [vinceliuice/Elegant-grub2-themes](https://github.com/vinceliuice/Elegant-grub2-themes) |
| `elegant-dark` | Elegant Dark | [vinceliuice/Elegant-grub2-themes](https://github.com/vinceliuice/Elegant-grub2-themes) |
| `sleek-dark` | Sleek Dark | [sandesh236/sleek--themes](https://github.com/sandesh236/sleek--themes) |
| `sleek-light` | Sleek Light | [sandesh236/sleek--themes](https://github.com/sandesh236/sleek--themes) |
| `sleek-orange` | Sleek Orange | [sandesh236/sleek--themes](https://github.com/sandesh236/sleek--themes) |

---

## 🖼️ Adding Your Own Wallpaper

1. Copy any **1920×1080** JPG or PNG image into `wallpapers/custom/`:
   ```bash
   cp ~/Pictures/my-image.jpg ~/grub_custom-looks/wallpapers/custom/
   ```
2. Open `config.cfg` and set:
   ```bash
   ACTIVE_WALL="my-image.jpg"
   ```
3. Apply:
   ```bash
   sudo ./manage.sh --apply
   ```

> **Tip:** GRUB supports `.jpg` and `.png` formats. Keep images at 1920×1080 for best results on a 1080p display.

---

## 🔷 Adding Your Own Icons

GRUB uses `.png` icon files named after the OS class. Icons live inside each installed theme's `icons/` folder.

```bash
# See current icons in your active theme:
ls /usr/share/grub/themes/tela/icons/

# Add or replace a specific OS icon:
sudo cp ~/Downloads/linuxmint.png /usr/share/grub/themes/tela/icons/linuxmint.png
```

Common icon filenames that match your current GRUB entries:
| Entry class | Icon filename needed |
|---|---|
| `ubuntu` | `ubuntu.png` |
| `fedora` / `nobara` | `fedora.png` |
| `gnu-linux` | `gnu-linux.png` |
| `uefi-firmware` | `efi.png` |

> No `update-grub` needed — icons are read directly at boot time.

---

## 🎨 Adding a New Theme from GitHub

```bash
# Step 1: Clone the theme repo into the themes/ folder
cd ~/grub_custom-looks/themes
git clone --depth=1 https://github.com/AUTHOR/theme-repo-name.git mytheme

# Step 2: Edit config.cfg
ACTIVE_THEME="mytheme"

# Step 3: Apply
sudo ~/grub_custom-looks/manage.sh --apply
```

> If the theme has no `install.sh`, see the "Manual Theme Install" section below.

---

## 📦 Manual Theme Install (no installer script)

Some themes are just a folder of files with no installer:

```bash
# Copy the theme folder to GRUB's themes directory:
sudo cp -r ~/Downloads/my-raw-theme/ /usr/share/grub/themes/my-raw-theme/

# Set it in GRUB config:
sudo nano /etc/default/grub
# → Change: GRUB_THEME="/usr/share/grub/themes/my-raw-theme/theme.txt"

# Apply:
sudo update-grub
```

---

## 🔄 Updating Themes

Since themes are Git repos, updating is simple:

```bash
# Update a specific theme:
cd ~/grub_custom-looks/themes/catppuccin
git pull

# Then re-apply:
sudo ~/grub_custom-looks/manage.sh --apply

# Or update ALL themes at once:
~/grub_custom-looks/manage.sh --download
```

---

## 📟 All Commands

```bash
# Interactive menu (recommended):
sudo ./manage.sh

# Apply settings from config.cfg silently:
sudo ./manage.sh --apply

# List all themes, wallpapers, icons, and current config:
./manage.sh --list

# Download / update all theme repos:
./manage.sh --download
```

---

## 🛠️ Requirements

- Linux Mint / Ubuntu or any Debian-based distro using GRUB2
- `git` installed (`sudo apt install git`)
- `bash` (pre-installed)
- `update-grub` (pre-installed on Mint/Ubuntu)

---

## 📝 Notes

- This tool **only manages visual appearance** of GRUB. It does not touch boot order, kernel entries, or EFI settings.
- Always run `--apply` with `sudo` as it writes to `/usr/share/grub/themes/` and `/etc/default/grub`.
- Your changes take effect on the **next reboot**.
- If something looks wrong after a theme switch, run `sudo update-grub` again or revert by re-running with a different theme.

---

## 📜 License

MIT — feel free to fork, modify, and share.
