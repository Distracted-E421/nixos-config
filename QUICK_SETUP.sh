#!/usr/bin/env bash
# NixOS Flake-Parts Configuration - Quick Setup Script
# Run this on your NixOS system to get started quickly

set -euo pipefail

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  NixOS Homelab Configuration - Quick Setup                   ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
info() { echo -e "${BLUE}ℹ${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; }

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    error "Please run as root (use sudo)"
    exit 1
fi

info "Starting NixOS configuration setup..."
echo ""

# 1. Check if we're in the right directory
if [ ! -f "flake.nix" ]; then
    error "flake.nix not found! Are you in the config directory?"
    exit 1
fi
success "Found flake.nix"

# 2. Get machine name
echo ""
info "What should we call this machine?"
read -p "Machine name (e.g., obsidian, framework, neon-laptop): " MACHINE_NAME

if [ -z "$MACHINE_NAME" ]; then
    error "Machine name cannot be empty"
    exit 1
fi

# 3. Create machine directory
info "Creating machine directory..."
mkdir -p "machines/$MACHINE_NAME"
success "Created machines/$MACHINE_NAME/"

# 4. Generate hardware configuration
info "Generating hardware configuration..."
nixos-generate-config --show-hardware-config > "machines/$MACHINE_NAME/hardware-configuration.nix"
success "Generated hardware-configuration.nix"

# 5. Detect boot device
info "Detecting boot device..."
BOOT_DEVICE=$(lsblk -ndo NAME | head -1)
info "Detected: /dev/$BOOT_DEVICE"
read -p "Is this correct? (y/n): " CONFIRM_BOOT

if [[ $CONFIRM_BOOT != "y" ]]; then
    read -p "Enter boot device (e.g., sda, nvme0n1): " BOOT_DEVICE
fi

# 6. Detect GPU
info "Detecting GPU..."
if lspci | grep -i nvidia &>/dev/null; then
    GPU_TYPE="nvidia"
    info "NVIDIA GPU detected"
elif lspci | grep -i intel.*vga &>/dev/null; then
    GPU_TYPE="intel"
    info "Intel GPU detected"
else
    GPU_TYPE="unknown"
    warn "Could not detect GPU type"
fi

# 7. Check if laptop
IS_LAPTOP="false"
if [ -d "/sys/class/power_supply/BAT0" ] || [ -d "/sys/class/power_supply/BAT1" ]; then
    IS_LAPTOP="true"
    info "Laptop detected (battery found)"
fi

# 8. Create machine configuration
info "Creating machine configuration..."
cat > "machines/$MACHINE_NAME/configuration.nix" << EOF
# $MACHINE_NAME Configuration
# Generated: $(date)

{ config, pkgs, lib, ... }:

{
  # Hostname
  networking.hostName = "$MACHINE_NAME";
  
  # Enable modules
  homelab = {
    # Desktop environments (enable ONE primary, others available as fallback)
    desktop = {
      hyprland.enable = true;      # Modern tiling Wayland
      kde-plasma.enable = true;    # Full-featured traditional
      gnome.enable = true;         # User-friendly traditional
    };
    
    # Applications
    apps = {
      media.enable = true;              # Spotify, VLC, OBS
      audio-production.enable = true;   # Audacity, LMMS
      torrents.enable = true;           # qBittorrent
      gaming.enable = true;             # Steam, Proton, GameMode
      development.enable = true;        # Cursor, languages, Docker
      browsers.enable = true;           # Firefox, Vivaldi, Brave
      productivity.enable = true;       # Office, Discord, Obsidian
    };
    
    # Hardware
    hardware = {
      gpu-nvidia.enable = $([ "$GPU_TYPE" = "nvidia" ] && echo "true" || echo "false");
      gpu-intel.enable = $([ "$GPU_TYPE" = "intel" ] && echo "true" || echo "false");
      laptop.enable = $IS_LAPTOP;
    };
    
    # System features
    system = {
      boot-menu.enable = true;     # Custom GRUB theme
      snapshots.enable = false;    # Enable if using btrfs
    };
  };
  
  # Bootloader configuration
  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      device = "/dev/$BOOT_DEVICE";
      # For UEFI systems, uncomment:
      # device = "nodev";
      # efiSupport = true;
    };
  };
}
EOF
success "Created configuration.nix"

# 9. Copy to /etc/nixos
info "Copying configuration to /etc/nixos..."
cp -r . /etc/nixos/
success "Copied to /etc/nixos/"

# 10. Initialize git repo
info "Initializing git repository..."
cd /etc/nixos
git init
git add .
git commit -m "Initial NixOS homelab configuration for $MACHINE_NAME"
success "Git repository initialized"

# 11. Summary
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Setup Complete! 🎉                                          ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
info "Machine: $MACHINE_NAME"
info "Boot device: /dev/$BOOT_DEVICE"
info "GPU: $GPU_TYPE"
info "Laptop: $IS_LAPTOP"
echo ""
echo "Next steps:"
echo ""
echo "1. Review the configuration:"
echo "   ${YELLOW}nano /etc/nixos/machines/$MACHINE_NAME/configuration.nix${NC}"
echo ""
echo "2. Build and activate:"
echo "   ${GREEN}cd /etc/nixos${NC}"
echo "   ${GREEN}sudo nixos-rebuild switch --flake .#$MACHINE_NAME${NC}"
echo ""
echo "3. After reboot, you can switch desktop environments at login"
echo ""
echo "4. Read the full documentation:"
echo "   ${BLUE}/etc/nixos/FLAKE_PARTS_GUIDE.md${NC}"
echo ""
success "Happy NixOS-ing! 🚀"
