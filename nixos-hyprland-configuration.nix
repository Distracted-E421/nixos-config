# NixOS Hyperland Configuration - Full GNOME Replacement
# Generated: 2025-10-15
# Target: nixos-test VM

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  # Networking
  networking.hostName = "nixos-test";
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "America/Chicago";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # ============================================
  # REMOVE GNOME
  # ============================================
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;

  # ============================================
  # DISPLAY MANAGER: greetd + tuigreet
  # ============================================
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${pkgs.hyprland}/bin/Hyprland";
        user = "greeter";
      };
    };
  };

  # ============================================
  # HYPERLAND: Native Wayland Compositor
  # ============================================
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG Desktop Portals (critical for file pickers, screen sharing)
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk  # Fallback for GTK apps
    ];
    config.common.default = "*";
  };

  # ============================================
  # AUDIO: PipeWire
  # ============================================
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # ============================================
  # SECURITY: Polkit (Qt-based)
  # ============================================
  security.polkit.enable = true;
  security.sudo.wheelNeedsPassword = false;  # For dev VM

  # ============================================
  # SYSTEM PACKAGES
  # ============================================
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # === HYPERLAND NATIVE TOOLS ===
    hyprlock           # Screen locker
    hypridle           # Idle daemon
    hyprpaper          # Wallpaper daemon
    
    # === STATUS BAR ===
    eww                # Ultimate customization (primary)
    waybar             # Fallback with autohide
    
    # === APPLICATION LAUNCHER ===
    rofi-wayland       # Wayland fork of rofi
    
    # === NOTIFICATIONS ===
    swaynotificationcenter  # Feature-rich with notification center
    libnotify          # For notify-send
    
    # === SCREENSHOTS & SCREEN RECORDING ===
    grim               # Screenshot tool
    slurp              # Region selector
    swappy             # Annotation tool
    wf-recorder        # Screen recording
    
    # === CLIPBOARD ===
    wl-clipboard       # CLI clipboard tools (wl-copy, wl-paste)
    cliphist           # Clipboard history manager
    wl-clip-persist    # Keep clipboard after app closes
    
    # === TERMINAL EMULATORS (ALL OF THEM!) ===
    kitty              # GPU-accelerated, feature-rich
    alacritty          # Minimal, fast, GPU-accelerated  
    foot               # Wayland-native, lightweight
    wezterm            # Lua-configurable, powerful
    
    # === FILE MANAGERS ===
    ranger             # Terminal file manager (primary)
    xfce.thunar       # GUI file manager (to try)
    xfce.tumbler       # Thumbnails for Thunar
    
    # === NETWORK MANAGEMENT ===
    networkmanagerapplet  # nm-applet (for EWW widget)
    
    # === AUDIO MANAGEMENT ===
    pavucontrol        # PulseAudio/PipeWire volume control
    helvum             # PipeWire patchbay
    
    # === BLUETOOTH ===
    blueman            # GUI Bluetooth manager
    bluetuith          # TUI Bluetooth manager
    
    # === POLKIT AGENT (Qt-based) ===
    lxqt.lxqt-policykit
    
    # === THEME/APPEARANCE ===
    nwg-look           # GTK theme settings
    qt5ct              # Qt5 appearance settings
    qt6ct              # Qt6 appearance settings
    libsForQt5.qtstyleplugin-kvantum  # Kvantum theme engine
    
    # === DEVELOPMENT TOOLS (from previous config) ===
    vim
    neovim
    git
    gh
    tig
    delta
    
    # === PYTHON ===
    python311
    python311Packages.pip
    python311Packages.virtualenv
    python311Packages.ipython
    
    # === BUILD TOOLS ===
    gcc
    cmake
    gnumake
    pkg-config
    
    # === LANGUAGES ===
    nodejs
    go
    rustc
    cargo
    
    # === BETTER CLI TOOLS ===
    bat
    eza
    ripgrep
    fd
    fzf
    zoxide
    direnv
    
    # === SYSTEM MONITORING ===
    htop
    btop
    iotop
    nethogs
    ncdu
    
    # === NETWORK TOOLS ===
    wget
    curl
    nmap
    netcat
    tcpdump
    bind
    whois
    
    # === DATA TOOLS ===
    jq
    yq
    
    # === UTILITIES ===
    tree
    unzip
    zip
    p7zip
    file
    which
    lsof
    strace
    
    # === VM INTEGRATION ===
    spice-vdagent
    
    # === BROWSERS ===
    firefox
    vivaldi
    
    # === ADDITIONAL HYPERLAND ECOSYSTEM ===
    hyprpicker         # Color picker
    wlogout            # Logout menu
    wlsunset           # Screen temperature (like redshift)
  ];

  # ============================================
  # ZSH CONFIGURATION (from previous)
  # ============================================
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "python" "docker" "sudo" "history" ];
      theme = "robbyrussell";
    };
    
    shellAliases = {
      # System management
      rebuild = "sudo nixos-rebuild switch";
      update = "sudo nixos-rebuild switch --upgrade";
      cleanup = "sudo nix-collect-garbage -d";
      
      # Navigation
      ll = "eza -lah --icons";
      la = "eza -A --icons";
      l = "eza -lh --icons";
      
      # Git shortcuts
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";
      gd = "git diff";
      
      # Docker shortcuts
      dps = "docker ps";
      dpa = "docker ps -a";
      di = "docker images";
      
      # Better tools
      cat = "bat";
      grep = "rg";
      find = "fd";
      top = "btop";
    };
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  # ============================================
  # USER ACCOUNT
  # ============================================
  users.users.e421 = {
    isNormalUser = true;
    description = "e421";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" ];
    shell = pkgs.zsh;
  };

  # ============================================
  # DOCKER
  # ============================================
  virtualisation.docker.enable = true;

  # ============================================
  # FIREFOX
  # ============================================
  programs.firefox.enable = true;

  # ============================================
  # GIT CONFIGURATION
  # ============================================
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # ============================================
  # SPICE AGENT (for clipboard in VM)
  # ============================================
  services.spice-vdagentd.enable = true;

  # ============================================
  # OPENSSH
  # ============================================
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # ============================================
  # FIREWALL
  # ============================================
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # ============================================
  # ENVIRONMENT VARIABLES
  # ============================================
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
    NIXOS_OZONE_WL = "1";  # Enable Wayland for Electron apps
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland,x11";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  # ============================================
  # SYSTEM VERSION
  # ============================================
  system.stateVersion = "24.05";
}

  # ============================================
  # VIRTIO-GPU SUPPORT FOR HYPERLAND IN VM
  # ============================================
  boot.kernelModules = [ "virtio_gpu" ];
  boot.initrd.kernelModules = [ "virtio_gpu" ];

  # Enable DRM and graphics support
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
