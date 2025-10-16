# NixOS Flake-Parts Configuration Guide

## 🎉 Overview

This is a comprehensive, modular NixOS configuration built with **flake-parts** for better organization and maintainability across multiple machines.

---

## 📁 **Directory Structure**

```
/etc/nixos/
├── flake.nix                    # Main flake with flake-parts
├── flake.lock                   # Locked dependencies
├── modules/
│   ├── common.nix               # Shared system configuration
│   ├── users/
│   │   └── e421.nix             # User account configuration
│   ├── desktop/
│   │   ├── hyprland.nix         # Hyprland (Wayland tiling)
│   │   ├── kde-plasma.nix       # KDE Plasma 6 (fallback)
│   │   └── gnome.nix            # GNOME (fallback)
│   ├── apps/
│   │   ├── media.nix            # Spotify, VLC, OBS
│   │   ├── audio-production.nix # Audacity, LMMS
│   │   ├── torrents.nix         # qBittorrent
│   │   ├── gaming.nix           # Steam, Proton, GameMode
│   │   ├── development.nix      # Cursor, languages, Docker
│   │   ├── browsers.nix         # Firefox, Vivaldi, Brave
│   │   └── productivity.nix     # Office, communication
│   ├── hardware/
│   │   ├── gpu-nvidia.nix       # NVIDIA drivers
│   │   ├── gpu-intel.nix        # Intel graphics
│   │   ├── laptop.nix           # Power management, touchpad
│   │   └── vm-guest.nix         # VM optimizations
│   └── system/
│       ├── boot-menu.nix        # Custom GRUB theme
│       └── snapshots.nix        # Btrfs snapshots
└── machines/
    ├── obsidian/
    │   ├── hardware-configuration.nix
    │   └── configuration.nix
    ├── nixos-test/
    ├── framework/
    ├── neon-laptop/
    └── pi-server/
```

---

## 🚀 **Quick Start**

### **1. Initialize your configuration:**

```bash
# On your new machine, copy your hardware-configuration.nix
sudo nixos-generate-config --show-hardware-config > /etc/nixos/machines/your-machine/hardware-configuration.nix

# Copy this entire config structure to /etc/nixos
sudo cp -r /path/to/this/config/* /etc/nixos/

# Initialize git repo
cd /etc/nixos
sudo git init
sudo git add .
sudo git commit -m "Initial NixOS flake-parts configuration"
```

### **2. Customize your machine configuration:**

Edit `/etc/nixos/machines/your-machine/configuration.nix`:

```nix
{ config, pkgs, lib, ... }:

{
  networking.hostName = "your-machine";
  
  # Enable the modules you want
  homelab = {
    desktop.hyprland.enable = true;
    apps.gaming.enable = true;
    apps.development.enable = true;
    hardware.gpu-intel.enable = true;
    system.boot-menu.enable = true;
  };
  
  # Your boot device
  boot.loader.grub.device = "/dev/sda";  # or /dev/nvme0n1
}
```

### **3. Build and activate:**

```bash
cd /etc/nixos
sudo nixos-rebuild switch --flake .#your-machine
```

---

## 🎮 **Module Options**

### **Desktop Environments:**

Enable **ONE primary** desktop, keep others available for fallback:

```nix
homelab.desktop = {
  hyprland.enable = true;      # Modern tiling Wayland compositor
  kde-plasma.enable = true;    # Full-featured traditional desktop
  gnome.enable = true;         # User-friendly traditional desktop
};
```

**To switch desktops:** Log out and select a different session from the display manager.

---

### **Applications:**

```nix
homelab.apps = {
  media.enable = true;              # Spotify, VLC, MPV, OBS
  audio-production.enable = true;   # Audacity, LMMS, Ardour
  torrents.enable = true;           # qBittorrent, Transmission
  gaming.enable = true;             # Steam, Lutris, GameMode, MangoHud
  development.enable = true;        # Cursor, Python, Node.js, Docker, etc
  browsers.enable = true;           # Firefox, Vivaldi, Brave, Chromium
  productivity.enable = true;       # LibreOffice, Discord, Obsidian
};
```

---

### **Hardware:**

```nix
homelab.hardware = {
  gpu-nvidia.enable = true;    # NVIDIA proprietary drivers + CUDA
  gpu-intel.enable = true;     # Intel integrated graphics + VA-API
  laptop.enable = true;        # TLP, battery care, touchpad
  vm-guest.enable = true;      # VirtIO, QEMU guest agent
};
```

---

### **System Features:**

```nix
homelab.system = {
  boot-menu.enable = true;     # Beautiful GRUB theme, larger fonts
  snapshots.enable = true;     # Btrfs snapshots with smart naming
};
```

---

## 📊 **Boot Menu Customization**

The custom boot menu module provides:

✅ **Larger fonts** (24pt menu, 32pt title)  
✅ **Modern theme** (Tela theme from vinceliuice)  
✅ **Better organization** (50 generations kept)  
✅ **Human-readable labels** (timestamps and descriptions)

**Commands:**

```bash
# List snapshots with nice formatting
list-snapshots

# Create a named snapshot
create-snapshot "Before major system upgrade"

# Update GRUB with snapshot entries
update-grub-snapshots
sudo nixos-rebuild boot
```

---

## 🔄 **Switching Desktop Environments**

You have **three desktop environments** available:

### **Primary: Hyprland (Wayland tiling)**
- Modern, GPU-accelerated
- Requires learning tiling keybinds
- Best for power users

### **Fallback 1: KDE Plasma 6**
- Traditional desktop with Wayland support
- Familiar Windows-like experience
- Very customizable

### **Fallback 2: GNOME**
- Simple, clean interface
- Works great out of the box
- macOS-like workflow

**How to switch:**

1. **Log out** of your current session
2. **At the login screen**, select your user
3. **Click the gear icon** (session selector)
4. **Choose:** "Hyprland", "Plasma (Wayland)", or "GNOME"
5. **Log in** to your new desktop environment

**If one DE has issues (e.g., Hyprland on bare metal):**

```bash
# Temporarily disable Hyprland, enable KDE
sudo nano /etc/nixos/machines/obsidian/configuration.nix

# Change:
homelab.desktop.hyprland.enable = false;
homelab.desktop.kde-plasma.enable = true;

# Rebuild
sudo nixos-rebuild switch --flake .#obsidian
```

---

## 🎨 **Gaming Module Features**

When you enable `homelab.apps.gaming.enable = true`, you get:

✅ **Steam** with Proton and game compatibility layers  
✅ **GameMode** - Automatic performance optimizations  
✅ **MangoHud** - FPS and performance overlay  
✅ **Lutris** - Universal game launcher  
✅ **Heroic** - Epic Games + GOG launcher  
✅ **Wine/Proton-GE** - Windows game compatibility  
✅ **Emulators** - RetroArch, PCSX2, RPCS3  

**Kernel optimizations included:**
- `vm.max_map_count` increased for games
- 32-bit graphics support
- Game controller drivers (Xbox, PlayStation)

---

## 🔧 **Common Workflows**

### **Update all packages:**

```bash
cd /etc/nixos
sudo nix flake update
sudo nixos-rebuild switch --flake .#obsidian
```

### **Add a new package from unstable:**

```nix
# In any module:
environment.systemPackages = [
  pkgs-unstable.your-package-here
];
```

### **Install a package temporarily (not persistent):**

```bash
nix shell nixpkgs#package-name
```

### **Search for packages:**

```bash
nix search nixpkgs package-name
```

### **Clean up old generations:**

```bash
sudo nix-collect-garbage -d
```

---

## 📦 **Adding a New Machine**

1. **Generate hardware config:**

```bash
sudo nixos-generate-config --show-hardware-config > /etc/nixos/machines/new-machine/hardware-configuration.nix
```

2. **Create configuration.nix:**

```bash
sudo nano /etc/nixos/machines/new-machine/configuration.nix
```

```nix
{ config, pkgs, lib, ... }:

{
  networking.hostName = "new-machine";
  
  homelab = {
    desktop.kde-plasma.enable = true;
    apps.development.enable = true;
    hardware.laptop.enable = true;  # If it's a laptop
  };
  
  boot.loader.grub.device = "/dev/sda";
}
```

3. **Add to flake.nix:**

```nix
# In nixosConfigurations:
new-machine = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs; pkgs-unstable = ...; };
  modules = [
    ./machines/new-machine/hardware-configuration.nix
    ./machines/new-machine/configuration.nix
    ./modules/common.nix
    ./modules/users/e421.nix
    # Add other modules as needed
  ];
};
```

4. **Build:**

```bash
sudo nixos-rebuild switch --flake .#new-machine
```

---

## 🆘 **Troubleshooting**

### **"Flake is dirty" error:**

```bash
cd /etc/nixos
sudo git add .
sudo git commit -m "Update config"
```

### **Need to test without committing:**

```bash
sudo nixos-rebuild switch --flake .#obsidian --impure
```

### **Hyprland won't start on bare metal:**

Switch to KDE Plasma or GNOME (see "Switching Desktop Environments" above).

### **Gaming performance issues:**

```bash
# Check GameMode is active
gamemoded -s

# Check MangoHud overlay
MANGOHUD=1 glxgears
```

### **Rollback to previous generation:**

```bash
sudo nixos-rebuild switch --rollback
```

### **Boot into previous generation:**

At boot, **select an older entry** from the GRUB menu (you have 50 generations available!).

---

## 📚 **Resources**

- **NixOS Manual:** https://nixos.org/manual/nixos/stable/
- **NixOS Search:** https://search.nixos.org/
- **Flake-parts:** https://flake.parts/
- **Hyprland Wiki:** https://wiki.hyprland.org/
- **This config on GitHub:** [Your repo URL here]

---

## ✨ **Features Summary**

✅ **Modular configuration** with flake-parts  
✅ **Multiple desktop environments** (easy switching)  
✅ **Gaming-optimized** (Steam, Proton, GameMode)  
✅ **Development-ready** (Cursor, Docker, languages)  
✅ **Media production** (Spotify, Audacity, OBS, VLC)  
✅ **Beautiful boot menu** (large fonts, organized)  
✅ **Smart snapshots** (btrfs with human-readable names)  
✅ **Hardware acceleration** (Intel/NVIDIA graphics)  
✅ **Power management** (laptops with TLP, battery care)  
✅ **Multi-machine support** (one config for all devices)  

---

**Date:** 2025-10-15  
**NixOS Version:** 24.05 (stable)  
**Unstable Channel:** Latest  
**Configuration:** Flake-parts based modular system
