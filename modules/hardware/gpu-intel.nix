# Intel GPU Module
# Intel integrated graphics with hardware acceleration

{ config, pkgs, lib, ... }:

{
  options = {
    homelab.hardware.gpu-intel.enable = lib.mkEnableOption "Intel GPU support";
  };

  config = lib.mkIf config.homelab.hardware.gpu-intel.enable {
    # Intel graphics driver
    services.xserver.videoDrivers = [ "modesetting" ];
    
    # OpenGL and Vulkan support
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      
      extraPackages = with pkgs; [
        # Intel hardware video acceleration
        intel-media-driver    # VAAPI for Broadwell+ (iHD)
        vaapiIntel           # VAAPI for older Intel (i965)
        vaapiVdpau
        libvdpau-va-gl
        
        # OpenCL support
        intel-compute-runtime
        intel-ocl
        
        # Vulkan
        vulkan-validation-layers
        vulkan-extension-layer
      ];
      
      extraPackages32 = with pkgs.pkgsi686Linux; [
        vaapiIntel
      ];
    };
    
    # Enable Intel GuC and HuC firmware
    boot.kernelParams = [
      "i915.enable_guc=3"    # Enable GuC and HuC
      "i915.enable_fbc=1"    # Enable framebuffer compression
    ];
    
    # Environment variables for hardware acceleration
    environment.variables = {
      LIBVA_DRIVER_NAME = "iHD";      # Use iHD driver (modern)
      # LIBVA_DRIVER_NAME = "i965";   # Use i965 for older GPUs
      VDPAU_DRIVER = "va_gl";
    };
    
    # Install Intel GPU tools
    environment.systemPackages = with pkgs; [
      intel-gpu-tools        # intel_gpu_top, etc
      libva-utils            # vainfo
      vdpauinfo              # vdpauinfo
      vulkan-tools           # vulkaninfo
      clinfo                 # OpenCL info
    ];
  };
}
