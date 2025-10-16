# GNOME Desktop Environment
# User-friendly traditional desktop (fallback option)

{ config, pkgs, pkgs-unstable, lib, ... }:

{
  options = {
    homelab.desktop.gnome.enable = lib.mkEnableOption "GNOME desktop environment";
  };

  config = lib.mkIf config.homelab.desktop.gnome.enable {
    # Enable X11/Wayland and GNOME
    services.xserver = {
      enable = true;
      
      # Display manager
      displayManager.gdm = {
        enable = true;
        wayland = true;  # Enable Wayland by default
      };
      
      # Desktop manager
      desktopManager.gnome.enable = true;
    };
    
    # Remove unwanted GNOME apps
    environment.gnome.excludePackages = with pkgs; [
      epiphany                       # Web browser (use Firefox/Vivaldi instead)
      geary                          # Email client
      gnome-tour
      gnome.totem                    # Video player (use VLC/MPV instead)
      gnome.yelp                     # Help viewer
    ];
    
    # Add useful GNOME apps
    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks             # Advanced settings
      gnomeExtensions.appindicator   # Tray icons
      gnomeExtensions.dash-to-dock   # Better dock
      gnomeExtensions.blur-my-shell  # Visual effects
      gnomeExtensions.vitals         # System monitor
      gnome.dconf-editor             # Advanced config editor
      gnome.gnome-disk-utility       # Disk management
    ];
    
    # GNOME-specific services
    services.gnome = {
      gnome-keyring.enable = true;
      gnome-browser-connector.enable = true;
    };
    
    # Enable PipeWire
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    
    # Wayland session variables
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
    
    # Fonts
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      cantarell-fonts
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
    ];
  };
}
