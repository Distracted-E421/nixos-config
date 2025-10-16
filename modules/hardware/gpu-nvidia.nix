# NVIDIA GPU Module
# NVIDIA proprietary drivers and CUDA support

{ config, pkgs, lib, ... }:

{
  options = {
    homelab.hardware.gpu-nvidia.enable = lib.mkEnableOption "NVIDIA GPU support";
  };

  config = lib.mkIf config.homelab.hardware.gpu-nvidia.enable {
    # NVIDIA drivers
    services.xserver.videoDrivers = [ "nvidia" ];
    
    hardware.nvidia = {
      # Use latest production driver
      package = config.boot.kernelPackages.nvidiaPackages.production;
      
      # Modesetting required for Wayland
      modesetting.enable = true;
      
      # Power management (recommended)
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      
      # Open source kernel module (beta, optional)
      open = false;
      
      # Enable nvidia-settings
      nvidiaSettings = true;
      
      # Prime support for hybrid graphics (laptops)
      prime = {
        # offload.enable = true;
        # intelBusId = "PCI:0:2:0";
        # nvidiaBusId = "PCI:1:0:0";
      };
    };
    
    # OpenGL/Vulkan support
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    
    # CUDA toolkit (optional, for ML/AI)
    # Uncomment if needed:
    # environment.systemPackages = with pkgs; [
    #   cudaPackages.cudatoolkit
    #   cudaPackages.cudnn
    # ];
    
    # Environment variables for NVIDIA
    environment.variables = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
    };
    
    # For Wayland compositors
    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
