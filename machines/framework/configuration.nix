# Framework Laptop Configuration
# Flexible: Switch between GUI and headless modes

{ config, pkgs, lib, ... }:

let
  # ============================================
  # CONFIGURATION SWITCH: GUI vs HEADLESS
  # ============================================
  # Set to true to enable GUI (Hyprland)
  # Set to false for headless server mode
  enableGUI = false;  # Change this to switch modes!
  
in {
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "framework";

  # ============================================
  # GUI MODE CONFIGURATION
  # ============================================
  # When enableGUI = true, Hyprland will be enabled
  # When enableGUI = false, no GUI (headless server)
  homelab.desktop.hyprland.enable = enableGUI;
  
  # ============================================
  # ALWAYS-ON CONFIGURATION
  # ============================================
  # Enable development tools and laptop features
  homelab.apps.development.enable = true;
  homelab.hardware.laptop.enable = true;
  
  # Enable k0s Kubernetes controller
  # Framework serves as the control plane for the homelab cluster
  homelab.services.k0s-controller = {
    enable = true;
    # Tailscale IP will be configured once Tailscale is set up
    # For now, bind to all interfaces
    tailscaleIP = "";  # Leave empty to bind to 0.0.0.0
    apiServerPort = 6443;
  };

  # ============================================
  # CONDITIONAL CONFIGURATION
  # ============================================
  # Headless mode: Auto-login to console for easy access
  # GUI mode: Normal login via greetd/Hyprland
  services.getty.autologinUser = lib.mkIf (!enableGUI) "e421";

  # Temporarily allow password SSH (will disable after setup complete)
  services.openssh.settings.PasswordAuthentication = lib.mkForce true;

  # System version
  system.stateVersion = "24.05";
}
