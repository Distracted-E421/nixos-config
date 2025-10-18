# Neon Laptop Configuration
# Mobile workstation with KDE Plasma

{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "neon-laptop";

  # Enable the desktop environment and applications
  homelab = {
    # KDE Plasma desktop
    desktop.kde-plasma.enable = true;
    
    # Full application suite
    apps = {
      development.enable = true;    # Dev tools, Docker, languages
      browsers.enable = true;        # Firefox, Vivaldi, etc.
      media.enable = true;           # Spotify, VLC, OBS
      productivity.enable = true;    # Discord, Obsidian, LibreOffice
      torrents.enable = true;        # qBittorrent
    };
    
    # Hardware support
    hardware = {
      laptop.enable = true;          # TLP, battery management
      gpu-intel.enable = true;       # Intel integrated graphics
    };
  };

  # System state version (don't change after initial install)
  system.stateVersion = "24.05";
}

