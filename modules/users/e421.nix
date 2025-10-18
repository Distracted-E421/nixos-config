# User: e421
# Main user account configuration

{ config, pkgs, lib, ... }:

{
  users.users.e421 = {
    isNormalUser = true;
    description = "e421";
    extraGroups = [ 
      "wheel"           # sudo access
      "networkmanager"  # network management
      "video"           # video devices
      "audio"           # audio devices
      "docker"          # docker access
      "libvirtd"        # virtual machines
      "input"           # input devices
      "plugdev"         # pluggable devices
    ];
    shell = pkgs.zsh;
    
    # Initial password: "nixos" (change after first login!)
    # Generated with: mkpasswd -m sha-512
    initialPassword = "nixos";
    
    # SSH authorized keys
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9oIyR76GP9/88hhpQfgB+50LmcvD5QJDMulMTgtRnZ e421@Obsidian"
    ];
  };
  
  # Passwordless sudo for wheel group (for development)
  security.sudo.wheelNeedsPassword = lib.mkDefault false;
}
