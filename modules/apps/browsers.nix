# Browsers Module
# Web browsers: Firefox, Vivaldi, Brave, Chromium

{ config, pkgs, pkgs-unstable, lib, ... }:

{
  options = {
    homelab.apps.browsers.enable = lib.mkEnableOption "web browsers";
  };

  config = lib.mkIf config.homelab.apps.browsers.enable {
    # Firefox with hardware acceleration
    programs.firefox = {
      enable = true;
      preferences = {
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        "gfx.webrender.all" = true;
        "layers.acceleration.force-enabled" = true;
      };
    };
    
    environment.systemPackages = with pkgs; [
      # Chromium-based browsers
      pkgs-unstable.vivaldi           # Feature-rich browser
      pkgs-unstable.vivaldi-ffmpeg-codecs
      brave                           # Privacy-focused
      chromium                        # Open-source Chrome
      
      # Firefox variants
      firefox-wayland                 # Firefox with Wayland support
      
      # Lightweight browsers
      qutebrowser                     # Keyboard-driven browser
      
      # Browser tools
      browserpass                     # Browser extension for pass
    ];
    
    # Set Vivaldi as default browser (can be changed)
    xdg.mime.defaultApplications = {
      "text/html" = "vivaldi-stable.desktop";
      "x-scheme-handler/http" = "vivaldi-stable.desktop";
      "x-scheme-handler/https" = "vivaldi-stable.desktop";
      "x-scheme-handler/about" = "vivaldi-stable.desktop";
      "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
    };
  };
}
