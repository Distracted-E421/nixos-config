# Productivity Module
# Office apps, communication, note-taking

{ config, pkgs, pkgs-unstable, lib, ... }:

{
  options = {
    homelab.apps.productivity.enable = lib.mkEnableOption "productivity applications";
  };

  config = lib.mkIf config.homelab.apps.productivity.enable {
    environment.systemPackages = with pkgs; [
      # === OFFICE SUITE ===
      libreoffice-fresh              # Office suite
      onlyoffice-bin                 # Alternative office suite
      
      # === PDF TOOLS ===
      okular                         # PDF viewer/editor
      evince                         # GNOME PDF viewer
      xournalpp                      # PDF annotation
      pdfarranger                    # PDF page arranger
      
      # === NOTE TAKING ===
      obsidian                       # Markdown notes
      logseq                         # Outliner notes
      joplin-desktop                 # Note taking app
      
      # === COMMUNICATION ===
      discord                        # Gaming/community chat
      slack                          # Work communication
      telegram-desktop               # Messaging
      signal-desktop                 # Secure messaging
      element-desktop                # Matrix client
      
      # === EMAIL ===
      thunderbird                    # Email client
      
      # === PRODUCTIVITY TOOLS ===
      obsidian                       # Knowledge management
      anki                           # Flashcards/spaced repetition
      calibre                        # E-book management
      
      # === SCREENSHOTS & RECORDING ===
      flameshot                      # Screenshot tool
      peek                           # GIF recorder
      
      # === UTILITIES ===
      keepassxc                      # Password manager
      syncthing                      # File synchronization
      rclone                         # Cloud storage sync
      
      # === DIAGRAMMING ===
      drawio                         # Diagrams
      inkscape                       # Vector graphics
      
      # === TIME MANAGEMENT ===
      gnome.gnome-calendar           # Calendar
      gnome.gnome-clocks             # World clocks/timers
    ];
    
    # Syncthing service (disabled by default)
    # services.syncthing = {
    #   enable = false;
    #   user = "e421";
    #   dataDir = "/home/e421/.syncthing";
    #   configDir = "/home/e421/.config/syncthing";
    # };
  };
}
