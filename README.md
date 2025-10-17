# NixOS Homelab Configuration 🚀

> **Professional-grade, modular NixOS configuration with flake-parts**

## ⚡ Quick Start

```bash
# 1. Copy this config to your system
sudo cp -r . /etc/nixos/

# 2. Edit your machine config
sudo nano /etc/nixos/machines/obsidian/configuration.nix

# 3. Build and activate
cd /etc/nixos
sudo nixos-rebuild switch --flake .#obsidian
```

---

## 📦 What You Get

### 🖥️ **Desktop Environments** (3 options)
- **Hyprland** - Modern tiling Wayland compositor
- **KDE Plasma 6** - Full-featured traditional desktop
- **GNOME** - User-friendly traditional desktop

### 🎮 **Gaming** (fully optimized)
- Steam with Proton
- GameMode + MangoHud
- Lutris, Heroic, Wine
- Emulators (RetroArch, PCSX2, RPCS3)

### 🎵 **Media**
- Spotify
- VLC, MPV
- OBS Studio
- Hardware acceleration

### 🎨 **Audio Production**
- Audacity
- LMMS
- Ardour
- PipeWire with JACK support

### 💻 **Development**
- Cursor IDE
- Python, Node.js, Go, Rust, C/C++
- Docker + Podman
- Kubernetes tools
- Neovim, Helix

### 🌐 **Browsers**
- Firefox
- Vivaldi (default)
- Brave
- Chromium

### 📁 **File Sharing**
- qBittorrent
- Transmission
- Deluge

### 🛠️ **Productivity**
- LibreOffice
- Discord, Slack, Telegram, Signal
- Obsidian
- KeePassXC

### ⚙️ **System Features**
- **Custom GRUB theme** with larger fonts
- **Btrfs snapshots** with smart naming
- **Hardware acceleration** (Intel/NVIDIA)
- **Power management** for laptops
- **VM optimizations**

---

## 📂 Structure

```
/etc/nixos/
├── flake.nix              # Main flake with flake-parts
├── modules/               # Modular configuration
│   ├── common.nix         # Base system
│   ├── users/             # User accounts
│   ├── desktop/           # DE options
│   ├── apps/              # Application modules
│   ├── hardware/          # Hardware support
│   └── system/            # Boot, snapshots
└── machines/              # Per-machine configs
    ├── obsidian/          # Main desktop
    ├── nixos-test/        # Test VM
    ├── framework/         # Framework laptop
    ├── neon-laptop/       # Neon laptop
    └── pi-server/         # Pi server
```

---

## 🎯 Module System

Everything is optional and modular:

```nix
homelab = {
  # Pick your desktop
  desktop.hyprland.enable = true;
  
  # Enable what you need
  apps = {
    gaming.enable = true;
    development.enable = true;
    media.enable = true;
  };
  
  # Hardware support
  hardware = {
    gpu-intel.enable = true;
    laptop.enable = true;  # If laptop
  };
  
  # System features
  system = {
    boot-menu.enable = true;  # Pretty GRUB
    snapshots.enable = true;  # Btrfs snapshots
  };
};
```

---

## 🔄 Switching Desktop Environments

All three DEs are available at login:

1. **Log out**
2. **Click the gear icon** at login screen
3. **Select:** Hyprland, Plasma, or GNOME
4. **Log in**

If one doesn't work (e.g., Hyprland issues), just switch to another!

---

## 📊 Boot Menu Features

✅ **24pt menu font** (easy to read)  
✅ **Modern Tela theme**  
✅ **50 generations kept** (organized by date)  
✅ **Human-readable labels**  

**Commands:**

```bash
list-snapshots                          # Pretty snapshot list
create-snapshot "Description"           # Named snapshot
update-grub-snapshots                   # Update boot menu
```

---

## 🎮 Gaming Optimizations

### **What's Included:**
- Steam with all compatibility layers
- Automatic GameMode activation
- MangoHud FPS overlay
- 32-bit graphics support
- Controller drivers (Xbox, PlayStation)
- Increased `vm.max_map_count` for games
- Wine, Proton-GE, Lutris, Heroic

### **How to Use:**

```bash
# Launch Steam
steam

# Launch game with MangoHud
mangohud steam steam://rungameid/YOUR_GAME_ID

# Check GameMode status
gamemoded -s

# Configure MangoHud
goverlay
```

---

## 🔧 Common Commands

```bash
# Update system
cd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch --flake .#obsidian

# Cleanup old generations
sudo nix-collect-garbage -d

# Search for packages
nix search nixpkgs package-name

# Try package temporarily
nix shell nixpkgs#package-name

# Rollback
sudo nixos-rebuild switch --rollback
```

---

## 📖 Full Documentation

See **[FLAKE_PARTS_GUIDE.md](./FLAKE_PARTS_GUIDE.md)** for:
- Detailed module documentation
- Adding new machines
- Troubleshooting
- Advanced configuration

---

## 🎯 Use Cases

### **Gaming Rig**
```nix
homelab = {
  desktop.hyprland.enable = true;
  apps.gaming.enable = true;
  apps.media.enable = true;
  apps.browsers.enable = true;
  hardware.gpu-nvidia.enable = true;
};
```

### **Development Laptop**
```nix
homelab = {
  desktop.kde-plasma.enable = true;
  apps.development.enable = true;
  apps.browsers.enable = true;
  apps.productivity.enable = true;
  hardware.gpu-intel.enable = true;
  hardware.laptop.enable = true;
};
```

### **Content Creation**
```nix
homelab = {
  desktop.gnome.enable = true;
  apps.media.enable = true;
  apps.audio-production.enable = true;
  apps.productivity.enable = true;
  hardware.gpu-nvidia.enable = true;
};
```

### **Server / Headless**
```nix
homelab = {
  # No desktop needed
  apps.development.enable = true;
};
```

---

## 🚨 Emergency Recovery

### **If system won't boot:**
1. **At GRUB menu**, select a previous generation
2. **Boot into it**
3. **Investigate the issue**
4. **Rollback permanently:** `sudo nixos-rebuild switch --rollback`

### **If desktop environment has issues:**
1. **Log out**
2. **Switch to a different DE** at login screen
3. **Fix the problematic DE** or disable it

### **If you broke something in config:**
```bash
cd /etc/nixos
sudo git log                    # Find last working commit
sudo git checkout COMMIT_HASH
sudo nixos-rebuild switch --flake .#obsidian
```

---

## 🌟 Features

✅ **Modular** - Enable only what you need  
✅ **Multi-desktop** - Switch anytime  
✅ **Gaming-ready** - Steam, Proton, GameMode  
✅ **Dev-friendly** - All major languages  
✅ **Beautiful boot** - Large fonts, organized  
✅ **Snapshots** - Automatic before rebuild  
✅ **Hardware** - Intel/NVIDIA support  
✅ **Batteries** - TLP power management  
✅ **Multi-machine** - One config, all devices  
✅ **Reproducible** - Flakes + lock file  

---

## 📝 License

MIT - Use however you like!

---

## 🙏 Credits

- NixOS community
- Hyprland developers
- Flake-parts maintainers
- vinceliuice (GRUB theme)

---

**Built with ❤️ for the homelab**

**NixOS 24.05 | Flake-Parts | Multi-Machine | Production-Ready**

# Auto-sync test - Fri Oct 17 12:36:22 PM CDT 2025
