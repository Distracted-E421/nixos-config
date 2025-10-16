# nixos-test VM Configuration
# TUI Mode - Testing headless/server configuration with SSH access

{ config, pkgs, lib, ... }:

{
  # Hostname
  networking.hostName = "nixos-test";
  
  # Enable module options (TUI server mode)
  homelab = {
    # NO Desktop environments - pure TUI mode
    desktop = {
      hyprland.enable = false;
      kde-plasma.enable = false;
      gnome.enable = false;
    };
    
    # Applications - minimal for server/TUI testing
    apps = {
      media.enable = false;              # Skip media apps in TUI
      audio-production.enable = false;   # Skip audio production
      torrents.enable = false;           # Skip torrents
      gaming.enable = false;             # Skip gaming
      development.enable = true;         # Keep dev tools for testing
      browsers.enable = false;           # No GUI browsers needed
      productivity.enable = false;       # Skip GUI productivity apps
    };
    
    # Hardware - VM specific
    hardware = {
      gpu-nvidia.enable = false;         # No GPU in VM
      gpu-intel.enable = false;          # No dedicated GPU
      laptop.enable = false;             # Not a laptop
      vm-guest.enable = true;            # ✓ Enable VM optimizations
    };
    
    # System features - TUI FOCUSED
    system = {
      boot-menu.enable = false;          # Skip custom GRUB for VM
      snapshots.enable = false;          # VM likely not btrfs
      tui-status.enable = true;          # ✓ Enable TUI dashboard!
    };
  };
  
  # Ensure SSH server is enabled and started
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = lib.mkForce true;  # Override common.nix for VM testing
    };
  };
  
  # Firewall - allow SSH
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];  # SSH
  };
  
  # Auto-login to console for easier troubleshooting
  # This allows access via virt-manager console if SSH fails
  services.getty.autologinUser = "e421";
  
  # Essential CLI tools for TUI environment
  environment.systemPackages = with pkgs; [
    # Network testing
    curl
    wget
    dig
    nmap
    
    # System utilities
    vim
    git
    tmux
    screen
  ];
  
  # System state version
  system.stateVersion = "24.05";
}
