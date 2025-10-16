# NixOS Homelab Configuration

<div align="center">

**Declarative, reproducible, multi-machine NixOS configuration**  
*Built with flake-parts • Secured with sops-nix • Deployed everywhere*

[![NixOS](https://img.shields.io/badge/NixOS-24.05-blue.svg?logo=nixos)](https://nixos.org)
[![Flakes](https://img.shields.io/badge/Nix-Flakes-informational.svg?logo=nixos)](https://nixos.wiki/wiki/Flakes)
[![sops-nix](https://img.shields.io/badge/Secrets-sops--nix-success.svg)](https://github.com/Mic92/sops-nix)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

</div>

---

## 📋 **Table of Contents**

- [Overview](#-overview)
- [Features](#-features)
- [Machine Configurations](#-machine-configurations)
- [Quick Start](#-quick-start)
- [Module System](#️-module-system)
- [Secrets Management](#-secrets-management)
- [Daily Usage](#-daily-usage)
- [Directory Structure](#-directory-structure)
- [Documentation](#-documentation)
- [Contributing](#-contributing)

---

## 🎯 **Overview**

This repository contains my complete NixOS homelab infrastructure configuration. It demonstrates modern NixOS best practices:

- **Flake-based** configuration with deterministic builds
- **Multi-machine** management from a single repository
- **Modular design** with 20+ reusable configuration modules
- **Secrets encryption** using sops-nix with age
- **Desktop flexibility** - Hyprland, KDE Plasma, and GNOME support
- **Hardware support** - NVIDIA, Intel Arc, laptops, VMs
- **Production-ready** with rollback capabilities

---

## **Features**

### **Architecture**

- ✅ **Flake-parts** for clean, organized configuration
- ✅ **sops-nix** for encrypted secrets in public repo
- ✅ **Unstable channel** mixing for bleeding-edge packages
- ✅ **Per-machine customization** with shared modules
- ✅ **Git-tracked** configuration history

### **🖥️ Desktop Environments**

- **Hyprland** - Modern, tiling Wayland compositor
- **KDE Plasma 6** - Feature-rich, familiar desktop
- **GNOME** - Clean, polished experience

### **📦 Application Suites**

- **Development** - Docker, Python, Node, Go, Rust, C++
- **Gaming** - Steam, Proton, GameMode, MangoHud, emulators
- **Media** - Spotify, VLC, OBS, mpv
- **Audio Production** - Audacity, LMMS, Ardour, Reaper
- **Productivity** - LibreOffice, Discord, Slack, Obsidian
- **Torrents** - qBittorrent, Transmission, Deluge

### **🔧 Hardware Profiles**

- **NVIDIA GPUs** - Proprietary drivers, CUDA support
- **Intel GPUs** - Arc A770 support, VA-API acceleration
- **Laptops** - TLP, battery care, touchpad, power management
- **VMs** - VirtIO-GPU, QEMU guest agent, optimizations

### **⚡ System Features**

- **Custom GRUB** - Large fonts, organized menu, 50 generations
- **Btrfs snapshots** - Snapper integration with smart naming
- **ZSH + Starship** - Beautiful shell with modern CLI tools
- **Zram** - Compressed swap for better performance
- **Automatic cleanup** - Garbage collection, optimization

---

## 🖥️ **Machine Configurations**

| Machine | Role | Desktop | Hardware | Status |
|---------|------|---------|----------|--------|
| **obsidian** | Main workstation | Hyprland/KDE/GNOME | Intel Arc A770 | ✅ Deployed |
| **nixos-test** | TUI testing VM | Headless | VM | ✅ Testing |
| **framework** | Headless server | None (TUI) | Framework laptop | 📅 Planned |
| **neon-laptop** | Mobile workstation | KDE Plasma | Intel iGPU | 📅 Planned |
| **pi-server** | ARM server | Headless | Raspberry Pi | 📅 Planned |

---

## 🚀 **Quick Start**

### **Prerequisites**

- NixOS 24.05 or later
- `nix-command` and `flakes` experimental features enabled
- SSH access to target machine (for remote deployment)

### **Option 1: Deploy to New Machine**

```bash
# Clone this repository
git clone https://github.com/Distracted-E421/nixos-config.git
cd nixos-config

# Generate hardware configuration for your machine
sudo nixos-generate-config --show-hardware-config > machines/your-machine/hardware-configuration.nix

# Copy and customize machine configuration
cp machines/nixos-test/configuration.nix machines/your-machine/configuration.nix
# Edit machines/your-machine/configuration.nix to enable desired modules

# Add machine to flake.nix (see existing examples)

# Build and activate
sudo nixos-rebuild switch --flake .#your-machine
```

### **Option 2: Remote Deployment (SSH)**

```bash
# From your local machine
./QUICK_SETUP.sh

# Or manually:
nix-shell -p nixos-rebuild --run "nixos-rebuild switch --flake .#target-machine --target-host user@hostname --use-remote-sudo"
```

### **Option 3: Test in VM First**

```bash
# Deploy to nixos-test VM (recommended for testing)
git clone https://github.com/Distracted-E421/nixos-config.git
cd nixos-config

# Build VM configuration
nixos-rebuild build-vm --flake .#nixos-test

# Run VM
./result/bin/run-nixos-vm
```

---

## 🛠️ **Module System**

Configuration is organized into reusable modules with simple enable/disable flags:

```nix
# machines/your-machine/configuration.nix
{
  networking.hostName = "your-machine";
  
  homelab = {
    # Desktop environments (enable one or multiple)
    desktop = {
      hyprland.enable = true;
      kde-plasma.enable = false;
      gnome.enable = false;
    };
    
    # Applications
    apps = {
      development.enable = true;
      gaming.enable = true;
      media.enable = true;
      productivity.enable = true;
    };
    
    # Hardware
    hardware = {
      gpu-nvidia.enable = false;
      gpu-intel.enable = true;
      laptop.enable = false;
    };
    
    # System features
    system = {
      boot-menu.enable = true;
      snapshots.enable = true;
    };
  };
}
```

### **Available Modules**

<details>
<summary><b>Desktop Environments</b></summary>

- `desktop/hyprland.nix` - Hyprland with waybar, rofi, etc.
- `desktop/kde-plasma.nix` - KDE Plasma 6
- `desktop/gnome.nix` - GNOME with extensions

</details>

<details>
<summary><b>Applications</b></summary>

- `apps/development.nix` - Full dev stack
- `apps/gaming.nix` - Steam, Proton, emulators
- `apps/media.nix` - Spotify, VLC, OBS
- `apps/audio-production.nix` - Audacity, LMMS
- `apps/torrents.nix` - qBittorrent, etc.
- `apps/browsers.nix` - Firefox, Vivaldi, Brave
- `apps/productivity.nix` - Office, chat, notes

</details>

<details>
<summary><b>Hardware</b></summary>

- `hardware/gpu-nvidia.nix` - NVIDIA proprietary drivers
- `hardware/gpu-intel.nix` - Intel GPU (including Arc)
- `hardware/laptop.nix` - TLP, battery, touchpad
- `hardware/vm-guest.nix` - VM optimizations

</details>

<details>
<summary><b>System Features</b></summary>

- `system/boot-menu.nix` - Beautiful GRUB theme
- `system/snapshots.nix` - Btrfs snapshots
- `system/tui-status.nix` - TUI dashboard

</details>

---

## 🔐 **Secrets Management**

This repository uses **sops-nix** to encrypt secrets with age encryption:

- ✅ **Encrypted secrets** committed safely to public repo
- ✅ **Per-machine keys** for granular access control
- ✅ **Automatic decryption** during system activation
- ✅ **Easy editing** with `sops` command

**Quick Start:**

```bash
# Generate age key on machine
sudo mkdir -p /var/lib/sops-nix
sudo nix-shell -p age --run "age-keygen -o /var/lib/sops-nix/key.txt"

# Get public key
sudo age-keygen -y /var/lib/sops-nix/key.txt

# Add to .sops.yaml and encrypt secrets
nix-shell -p sops --run "sops secrets/secrets.yaml"
```

**Full documentation:** [`secrets/SETUP_GUIDE.md`](secrets/SETUP_GUIDE.md)

---

## 📅 **Daily Usage**

### **Update System**

```bash
cd /path/to/nixos-config
sudo nix flake update
sudo nixos-rebuild switch --flake .#$(hostname)
```

### **Add New Package**

```nix
# In appropriate module or machine config
environment.systemPackages = with pkgs; [
  your-new-package
];
```

### **Switch Desktop Environment**

Just log out and select different session at login screen! All installed DEs are available.

### **Rollback**

```bash
# View generations
sudo nixos-rebuild list-generations

# Rollback
sudo nixos-rebuild switch --rollback

# Or select specific generation from GRUB menu
```

---

## 📁 **Directory Structure**

```
nixos-config/
├── flake.nix                    # Main flake definition
├── flake.lock                   # Dependency pins
├── .sops.yaml                   # sops encryption config
├── README.md                    # This file
├── FLAKE_PARTS_GUIDE.md        # Detailed usage guide
├── QUICK_SETUP.sh              # Automated setup script
│
├── machines/                    # Per-machine configurations
│   ├── obsidian/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   ├── nixos-test/
│   ├── framework/
│   ├── neon-laptop/
│   └── pi-server/
│
├── modules/                     # Reusable configuration modules
│   ├── common.nix              # Shared settings
│   ├── secrets.nix             # sops-nix configuration
│   ├── users/
│   │   └── e421.nix
│   ├── desktop/
│   │   ├── hyprland.nix
│   │   ├── kde-plasma.nix
│   │   └── gnome.nix
│   ├── apps/
│   │   ├── development.nix
│   │   ├── gaming.nix
│   │   ├── media.nix
│   │   └── ...
│   ├── hardware/
│   │   ├── gpu-nvidia.nix
│   │   ├── gpu-intel.nix
│   │   ├── laptop.nix
│   │   └── vm-guest.nix
│   └── system/
│       ├── boot-menu.nix
│       └── snapshots.nix
│
├── secrets/                     # Encrypted secrets
│   ├── SETUP_GUIDE.md          # Secrets setup guide
│   ├── .gitignore              # Protect private keys
│   └── secrets.yaml            # Encrypted secrets file
│
└── hyprland/                    # Hyperland dotfiles
    └── hyprland.conf
```

---

## 📚 **Documentation**

- **[FLAKE_PARTS_GUIDE.md](FLAKE_PARTS_GUIDE.md)** - Complete usage guide
- **[secrets/SETUP_GUIDE.md](secrets/SETUP_GUIDE.md)** - Secrets management
- **[PASSWORD_MANAGEMENT_PLAN.md](PASSWORD_MANAGEMENT_PLAN.md)** - Security roadmap

---

## 🤝 **Contributing**

This is a personal configuration, but feel free to:

- ⭐ Star if you find it useful
- 🍴 Fork and adapt for your own setup
- 🐛 Open issues for bugs or questions
- 💡 Share improvements via PRs

---

## 📜 **License**

MIT License - Feel free to use and modify!

---

## 🙏 **Acknowledgments**

- **NixOS Community** - Amazing documentation and support
- **sops-nix** by @Mic92 - Making secrets management elegant
- **Flake-parts** by @hercules-ci - Clean flake organization
- **Hyprland** - Modern Wayland compositor

---

## 📞 **Contact**

- **GitHub:** [@Distracted-E421](https://github.com/Distracted-E421)
- **Repository:** [nixos-config](https://github.com/Distracted-E421/nixos-config)

---

<div align="center">

**Built with ❤️ using NixOS**  
*Declarative • Reproducible • Reliable*

</div>
