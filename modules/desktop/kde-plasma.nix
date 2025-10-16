# KDE Plasma Desktop Environment
# Full-featured traditional desktop (fallback option)

{ config, pkgs, pkgs-unstable, lib, ... }:

{
  options = {
    homelab.desktop.kde-plasma.enable = lib.mkEnableOption "KDE Plasma desktop environment";
  };

  config = lib.mkIf config.homelab.desktop.kde-plasma.enable {
    # Enable X11 and KDE Plasma
    services.xserver = {
      enable = true;
      
      # Display manager
      displayManager.sddm.enable = true;
      displayManager.sddm.wayland.enable = true;
      
      # Desktop manager
      desktopManager.plasma6.enable = true;
    };
    
    # KDE/Plasma specific packages
    environment.systemPackages = with pkgs; [
      # KDE Applications
      kdePackages.kate                # Text editor
      kdePackages.konsole             # Terminal
      kdePackages.dolphin             # File manager
      kdePackages.ark                 # Archive manager
      kdePackages.okular              # Document viewer
      kdePackages.gwenview            # Image viewer
      kdePackages.spectacle           # Screenshot tool
      kdePackages.kcalc               # Calculator
      kdePackages.filelight           # Disk usage analyzer
      kdePackages.partitionmanager    # Partition manager
      kdePackages.plasma-browser-integration
      
      # KDE Connect for phone integration
      kdePackages.kdeconnect-kde
      
      # System monitoring
      kdePackages.ksystemlog
      kdePackages.plasma-systemmonitor
    ];
    
    # KDE-specific services
    programs.kdeconnect.enable = true;
    
    # Enable PipeWire (better than PulseAudio)
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    
    # Wayland session support
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";          # Electron apps use Wayland
      MOZ_ENABLE_WAYLAND = "1";      # Firefox Wayland
    };
    
    # Fonts
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
    ];
    
    # Plasma desktop portals
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    };
  };
}
