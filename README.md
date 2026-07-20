# grub_custom-looks

I got tired of manually copying theme files and editing `/etc/default/grub` every time I wanted to try a different GRUB theme. So I made this — a simple script that handles all of it.

Drop a wallpaper in a folder. Pick a theme key. Run one command. Done.

---

## What it does

- Downloads and installs GRUB themes from the best community repos
- Lets you swap wallpapers without touching any system files manually
- Switches icon styles (color, white, macOS-style)
- Rebuilds GRUB automatically after any change
- Remembers your choices in a plain `config.cfg` file you can edit with any text editor

---

## Folder layout

```
grub_custom-looks/
├── manage.sh          ← run this
├── config.cfg         ← your settings
├── wallpapers/        ← drop images here
│   └── custom/        ← your own personal walls go here
├── icons/
│   └── custom/        ← your own icons go here
└── themes/            ← theme repos get cloned here
```

---

## Getting started

```bash
git clone https://github.com/saquib-byte/grub_custom-looks.git ~/grub_custom-looks
cd ~/grub_custom-looks
chmod +x manage.sh

# download all theme repos
./manage.sh --download

# see what's available
./manage.sh --list

# interactive menu — easiest way to get started
sudo ./manage.sh
```

---

## Switching themes

Edit `config.cfg`:

```bash
ACTIVE_THEME="catppuccin-mocha"
ACTIVE_ICONS="white"
ACTIVE_WALL="auto"
RESOLUTION="1080p"
```

Then apply:

```bash
sudo ./manage.sh --apply
```

That's it. GRUB gets rebuilt automatically.

---

## Adding your own wallpaper

Copy any 1920×1080 JPG or PNG into `wallpapers/custom/`, then set it in `config.cfg`:

```bash
ACTIVE_WALL="your-image.jpg"
```

Run `sudo ./manage.sh --apply` and it'll show up next boot.

---

## Adding your own icons

GRUB uses `.png` files named after the OS class (e.g. `ubuntu.png`, `fedora.png`). Drop replacements into your active theme's icons folder:

```bash
sudo cp my-icon.png /usr/share/grub/themes/tela/icons/linuxmint.png
```

No `update-grub` needed — icons are picked up at boot time.

---

## Adding a theme from GitHub

```bash
cd ~/grub_custom-looks/themes
git clone --depth=1 https://github.com/AUTHOR/some-grub-theme.git mytheme
```

Then in `config.cfg` set `ACTIVE_THEME="mytheme"` and run `sudo ./manage.sh --apply`.

---

## Updating themes

```bash
# update one
cd ~/grub_custom-looks/themes/catppuccin && git pull

# update all at once
~/grub_custom-looks/manage.sh --download
```

---

## All commands

```
./manage.sh              interactive menu
sudo ./manage.sh --apply apply config.cfg and rebuild GRUB
./manage.sh --list       show themes, walls, icons, current config
./manage.sh --download   download or update all theme repos
./manage.sh --help       show help
```

---

## Themes included

| Key | Name | Source |
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

## Requirements

- Linux Mint / Ubuntu or any Debian-based distro with GRUB2
- `git` — `sudo apt install git`
- `bash` — already there
- `update-grub` — already there

---

## License

MIT
