# Hyprland Desktop Environment
# Modern tiling Wayland compositor

{ config, pkgs, pkgs-unstable, inputs, lib, ... }:

{
  options = {
    homelab.desktop.hyprland.enable = lib.mkEnableOption "Hyprland desktop environment";
  };

  config = lib.mkIf config.homelab.desktop.hyprland.enable {
    # Enable Hyprland
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    
    # Display manager - greetd with tuigreet
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
          user = "greeter";
        };
      };
    };
    
    # XDG Desktop Portals - handled automatically by programs.hyprland
    # Just ensure xdg-desktop-portal-gtk is available for file pickers
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
    
    # Hyprland ecosystem packages
    environment.systemPackages = with pkgs; [
      # === HYPRLAND NATIVE TOOLS ===
      hyprlock                       # Screen locker
      hypridle                       # Idle daemon
      hyprpaper                      # Wallpaper daemon
      hyprpicker                     # Color picker
      
      # === STATUS BAR ===
      waybar                         # Wayland status bar
      eww                            # Widget system
      
      # === APPLICATION LAUNCHER ===
      rofi-wayland                   # Application launcher
      wofi                           # Alternative launcher
      fuzzel                         # Minimal launcher
      
      # === NOTIFICATIONS ===
      mako                           # Notification daemon
      dunst                          # Alternative notification daemon
      swaynotificationcenter         # Feature-rich notification center
      libnotify                      # For notify-send
      
      # === SCREENSHOTS & SCREEN RECORDING ===
      grim                           # Screenshot tool
      slurp                          # Region selector
      swappy                         # Screenshot annotation
      wf-recorder                    # Screen recording
      wl-screenrec                   # Alternative screen recorder
      
      # === CLIPBOARD ===
      wl-clipboard                   # CLI clipboard (wl-copy, wl-paste)
      cliphist                       # Clipboard history manager
      wl-clip-persist                # Persist clipboard after app closes
      
      # === TERMINAL EMULATORS ===
      kitty                          # GPU-accelerated terminal
      alacritty                      # Minimal fast terminal
      foot                           # Wayland-native terminal
      wezterm                        # Feature-rich terminal
      
      # === FILE MANAGERS ===
      ranger                         # TUI file manager
      yazi                           # Modern TUI file manager
      xfce.thunar                    # GUI file manager
      xfce.thunar-volman             # Removable drive support
      xfce.tumbler                   # Thumbnails for Thunar
      
      # === NETWORK MANAGEMENT ===
      networkmanagerapplet           # nm-applet
      
      # === AUDIO MANAGEMENT ===
      pavucontrol                    # Volume control GUI
      pwvucontrol                    # Pipewire volume control
      helvum                         # PipeWire patchbay
      
      # === BLUETOOTH ===
      blueman                        # Bluetooth manager
      bluetuith                      # TUI Bluetooth manager
      
      # === POLKIT AGENT ===
      polkit_gnome                   # Polkit authentication agent
      lxqt.lxqt-policykit            # Alternative polkit agent
      
      # === THEME/APPEARANCE ===
      nwg-look                       # GTK theme configurator
      qt5ct                          # Qt5 appearance
      qt6ct                          # Qt6 appearance
      libsForQt5.qtstyleplugin-kvantum
      
      # === UTILITIES ===
      wlogout                        # Logout menu
      wlsunset                       # Screen temperature
      brightnessctl                  # Backlight control
      playerctl                      # Media player control
      wev                            # Wayland event viewer (debugging)
      wlr-randr                      # Display configuration
      
      # === IMAGE VIEWERS ===
      imv                            # Wayland image viewer
      swayimg                        # Fast image viewer
      
      # === WALLPAPERS ===
      swaybg                         # Alternative wallpaper daemon
      wpaperd                        # Modern wallpaper daemon
    ];
    
    # Wayland environment variables
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";          # Electron apps use Wayland
      MOZ_ENABLE_WAYLAND = "1";      # Firefox Wayland
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      GDK_BACKEND = "wayland,x11";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };
    
    # Polkit service
    security.polkit.enable = true;
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    
    # Fonts for Waybar and other UI elements
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "Hack" ]; })
    ];
    
    # Screen sharing support
    services.dbus.enable = true;
    xdg.portal.wlr.enable = true;
    
    # Enable XWayland for legacy apps
    services.xserver.enable = true;
  };
}
