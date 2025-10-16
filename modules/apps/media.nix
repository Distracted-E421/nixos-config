# Media Applications Module
# Spotify, VLC, MPV, media codecs

{ config, pkgs, pkgs-unstable, lib, ... }:

{
  options = {
    homelab.apps.media.enable = lib.mkEnableOption "media applications";
  };

  config = lib.mkIf config.homelab.apps.media.enable {
    # Media packages
    environment.systemPackages = with pkgs; [
      # Music streaming
      pkgs-unstable.spotify          # Music streaming
      
      # Video players
      vlc                            # Versatile media player
      mpv                            # Lightweight video player
      celluloid                      # GTK frontend for MPV
      
      # Audio players
      rhythmbox                      # Music library manager
      audacious                      # Lightweight audio player
      
      # Media tools
      mediainfo                      # Media file information
      ffmpeg-full                    # Media encoding/decoding
      yt-dlp                         # YouTube downloader
      
      # Streaming
      obs-studio                     # Streaming/recording
      obs-studio-plugins.obs-vkcapture
      obs-studio-plugins.obs-pipewire-audio-capture
    ];
    
    # PipeWire for audio (required for modern audio)
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      
      # Low latency configuration
      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 2048;
        };
      };
    };
    
    # Media codecs and hardware acceleration
    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver  # VAAPI for Intel (Broadwell+)
        vaapiIntel         # VAAPI for older Intel
        vaapiVdpau
        libvdpau-va-gl
        intel-compute-runtime  # OpenCL for Intel
      ];
    };
    
    # Allow Spotify and other unfree packages
    nixpkgs.config.allowUnfree = true;
    
    # Environment variables for hardware acceleration
    environment.variables = {
      LIBVA_DRIVER_NAME = "iHD";  # Intel iHD driver
    };
  };
}
