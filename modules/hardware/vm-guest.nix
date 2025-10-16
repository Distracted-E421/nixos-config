# VM Guest Module
# Optimizations for running NixOS as a VM guest

{ config, pkgs, lib, ... }:

{
  options = {
    homelab.hardware.vm-guest.enable = lib.mkEnableOption "VM guest optimizations";
  };

  config = lib.mkIf config.homelab.hardware.vm-guest.enable {
    # VirtIO drivers and optimizations
    boot.kernelModules = [ 
      "virtio_balloon"
      "virtio_blk"
      "virtio_net"
      "virtio_pci"
      "virtio_scsi"
      "virtio_gpu"
    ];
    
    boot.initrd.kernelModules = [
      "virtio_balloon"
      "virtio_blk"
      "virtio_net"
      "virtio_pci"
      "virtio_scsi"
      "virtio_gpu"
    ];
    
    # OpenGL support for virtio-gpu
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    
    # QEMU guest agent for better host integration
    services.qemuGuest.enable = true;
    
    # SPICE agent for clipboard sharing and display
    services.spice-vdagentd.enable = true;
    services.spice-webdavd.enable = true;
    
    # Install guest tools
    environment.systemPackages = with pkgs; [
      spice-vdagent
      spice-gtk
      virtiofsd
    ];
    
    # Disable unnecessary services in VMs
    services.thermald.enable = false;
    services.tlp.enable = false;
    powerManagement.cpuFreqGovernor = lib.mkForce null;
    
    # VM-specific kernel parameters
    boot.kernelParams = [
      "quiet"
      "splash"
    ];
    
    # Prefer X11 over Wayland in VMs (better compatibility)
    # Comment this out if you want to test Wayland
    environment.sessionVariables = {
      # Force X11 for better VM compatibility
      GDK_BACKEND = "x11";
      CLUTTER_BACKEND = "x11";
    };
  };
}
