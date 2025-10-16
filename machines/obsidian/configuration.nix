# Obsidian Desktop Configuration
# Main workstation with gaming, development, and media capabilities

{ config, pkgs, lib, ... }:

{
  # Hostname
  networking.hostName = "obsidian";
  
  # Enable module options
  homelab = {
    # Desktop environments (enable ONE primary, keep others available)
    desktop = {
      hyprland.enable = true;      # Primary: Modern tiling Wayland
      kde-plasma.enable = true;    # Fallback: Full-featured traditional
      gnome.enable = true;         # Fallback: User-friendly traditional
    };
    
    # Applications
    apps = {
      media.enable = true;              # Spotify, VLC, OBS
      audio-production.enable = true;   # Audacity, LMMS
      torrents.enable = true;           # qBittorrent
      gaming.enable = true;             # Steam, Proton, GameMode
      development.enable = true;        # Cursor, Python, Node.js, etc
      browsers.enable = true;           # Firefox, Vivaldi, Brave
      productivity.enable = true;       # Office, Discord, etc
    };
    
    # Hardware
    hardware = {
      gpu-nvidia.enable = false;   # Set to true if you have NVIDIA GPU
      gpu-intel.enable = true;     # Set to true if you have Intel GPU
    };
    
    # System features
    system = {
      boot-menu.enable = true;     # Custom GRUB theme and organization
      snapshots.enable = true;     # Btrfs snapshots with smart naming
    };
  };
  
  # Bootloader configuration
  boot.loader = {
    systemd-boot.enable = false;   # We're using GRUB
    grub = {
      enable = true;
      device = "/dev/sda";  # Change to your boot device (e.g., /dev/nvme0n1)
      # For UEFI systems, use:
      # device = "nodev";
      # efiSupport = true;
    };
  };
  
  # Additional machine-specific configuration
  # Add your hardware-configuration.nix specifics here
}
