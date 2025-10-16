# Audio Production Module
# Audacity, LMMS, audio editing tools

{ config, pkgs, pkgs-unstable, lib, ... }:

{
  options = {
    homelab.apps.audio-production.enable = lib.mkEnableOption "audio production applications";
  };

  config = lib.mkIf config.homelab.apps.audio-production.enable {
    environment.systemPackages = with pkgs; [
      # Audio editing
      audacity                       # Multi-track audio editor
      tenacity                       # Audacity fork
      ocenaudio                      # Easy audio editor
      
      # Music production
      lmms                           # Digital audio workstation
      ardour                         # Professional DAW
      reaper                         # Commercial DAW (demo)
      
      # Audio plugins
      calf                           # Audio plugin pack
      
      # Audio utilities
      pavucontrol                    # PulseAudio/PipeWire control
      helvum                         # PipeWire patchbay
      qpwgraph                       # PipeWire graph manager
      carla                          # Audio plugin host
      
      # Audio analysis
      sonic-visualiser               # Audio analysis
      spek                           # Acoustic spectrum analyzer
    ];
    
    # JACK support for professional audio (via PipeWire)
    services.pipewire.jack.enable = true;
    
    # Add user to audio group
    users.users.e421.extraGroups = [ "audio" ];
    
    # Real-time audio scheduling
    security.pam.loginLimits = [
      { domain = "@audio"; type = "-"; item = "rtprio"; value = "95"; }
      { domain = "@audio"; type = "-"; item = "memlock"; value = "unlimited"; }
      { domain = "@audio"; type = "-"; item = "nice"; value = "-19"; }
    ];
  };
}
