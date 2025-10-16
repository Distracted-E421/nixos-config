# Gaming Module
# Steam, Proton, game launchers, gaming optimizations

{ config, pkgs, pkgs-unstable, lib, ... }:

{
  options = {
    homelab.apps.gaming.enable = lib.mkEnableOption "gaming applications and optimizations";
  };

  config = lib.mkIf config.homelab.apps.gaming.enable {
    # Steam and gaming packages
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      
      # Extra compatibility tools
      gamescopeSession.enable = true;
    };
    
    # GameMode - automatic performance optimizations
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          amd_performance_level = "high";
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
    
    environment.systemPackages = with pkgs; [
      # Game launchers
      lutris                         # Universal game launcher
      heroic                         # Epic Games + GOG launcher
      bottles                        # Wine prefix manager
      
      # Wine and compatibility layers
      wineWowPackages.stable         # 32-bit + 64-bit Wine
      wineWowPackages.staging        # Wine with extra patches
      winetricks                     # Wine helper scripts
      
      # Proton-GE (community builds)
      protonup-qt                    # Proton-GE manager
      
      # Game streaming
      moonlight-qt                   # NVIDIA GameStream client
      sunshine                       # Game streaming server
      
      # Performance overlays
      mangohud                       # Performance overlay
      goverlay                       # MangoHud configurator
      
      # Game tools
      discord                        # Voice chat
      teamspeak_client               # Alternative voice chat
      
      # Emulators
      retroarch                      # Multi-system emulator
      pcsx2                          # PS2 emulator
      rpcs3                          # PS3 emulator
      
      # Controllers
      xboxdrv                        # Xbox controller driver
      antimicrox                     # Controller-to-keyboard mapper
    ];
    
    # Gaming-specific hardware support
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;  # Required for 32-bit games
    };
    
    # Enable Xbox controller support
    hardware.xone.enable = true;
    hardware.xpadneo.enable = true;
    
    # Kernel parameters for gaming
    boot.kernel.sysctl = {
      "vm.max_map_count" = 2147483642;  # Required for some games
      "fs.file-max" = 524288;           # Increase file descriptor limit
    };
    
    # Gaming group permissions
    users.users.e421.extraGroups = [ "gamemode" ];
    
    # Environment variables for gaming
    environment.variables = {
      # AMD GPU optimizations (if applicable)
      # AMD_VULKAN_ICD = "RADV";
      
      # MangoHud
      MANGOHUD = "1";
      MANGOHUD_CONFIG = "fps,frametime,cpu_temp,gpu_temp,ram,vram";
      
      # Proton optimizations
      PROTON_ENABLE_NVAPI = "1";
      PROTON_ENABLE_NGX_UPDATER = "1";
      
      # Wine optimizations
      WINE_CPU_TOPOLOGY = "8:0,1,2,3,4,5,6,7";
    };
    
    # Gaming-related services
    services.flatpak.enable = true;  # Some games distributed via Flatpak
    
    # Firewall rules for game streaming
    networking.firewall.allowedTCPPorts = [ 47984 47989 48010 ];
    networking.firewall.allowedUDPPorts = [ 47998 47999 48000 48010 ];
  };
}
