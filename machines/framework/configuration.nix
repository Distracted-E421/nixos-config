# Framework Laptop Configuration
# Headless TUI server role with development tools

{ config, pkgs, lib, ... }:

{
  # Hostname
  networking.hostName = "framework";
  
  # Enable module options (Headless/TUI server mode)
  homelab = {
    # NO Desktop environments - pure TUI mode
    desktop = {
      hyprland.enable = false;
      kde-plasma.enable = false;
      gnome.enable = false;
    };
    
    # Applications - server/development focused
    apps = {
      media.enable = false;              # Skip media apps
      audio-production.enable = false;   # Skip audio production
      torrents.enable = false;           # Skip torrents
      gaming.enable = false;             # Skip gaming
      development.enable = true;         # ✓ Keep dev tools
      browsers.enable = false;           # No GUI browsers needed
      productivity.enable = false;       # Skip GUI productivity apps
    };
    
    # Hardware - Framework laptop specific
    hardware = {
      gpu-nvidia.enable = false;         # No NVIDIA
      gpu-intel.enable = true;           # ✓ Intel iGPU
      laptop.enable = true;              # ✓ Laptop optimizations
      vm-guest.enable = false;           # Not a VM
    };
    
    # System features - TUI FOCUSED
    system = {
      boot-menu.enable = false;          # Keep boot menu simple for server
      snapshots.enable = false;          # Skip btrfs for now (ext4)
      tui-status.enable = true;          # ✓ Enable TUI dashboard!
    };
  };
  
  # Ensure SSH server is enabled and started
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = lib.mkForce true;  # Keep password auth for now
    };
  };
  
  # Firewall - allow SSH
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];  # SSH
  };
  
  # Auto-login to console for easier troubleshooting
  # Can be disabled later once everything is stable
  services.getty.autologinUser = "e421";
  
  # Essential CLI tools for server environment
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
    htop
    btop
    
    # Monitoring
    iotop
    nethogs
  ];
  
  # System state version
  system.stateVersion = "24.05";
}
