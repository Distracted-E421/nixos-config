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
    
    # SSH authorized keys
    openssh.authorizedKeys.keys = [
      # Add your SSH public keys here
      # "ssh-ed25519 AAAAC3... your-key@hostname"
    ];
  };
  
  # Passwordless sudo for wheel group (for development)
  security.sudo.wheelNeedsPassword = lib.mkDefault false;
}
