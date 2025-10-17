# Common System Configuration
# Settings shared across all machines

{ config, pkgs, lib, ... }:

{
  # Nix settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };
    
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  
  # Allow unfree packages globally
  nixpkgs.config.allowUnfree = true;
  
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
  
  # Networking
  networking.networkmanager.enable = true;
  
  # Core system packages (available on all machines)
  environment.systemPackages = with pkgs; [
    # Essential CLI tools
    vim
    git
    wget
    curl
    htop
    tree
    unzip
    zip
    p7zip
    
    # Better CLI tools
    bat
    eza
    ripgrep
    fd
    fzf
    
    # System tools
    lsof
    strace
    file
    which
    tmux
    
    # Network tools
    nmap
    netcat
    bind
    whois
    
    # GitHub CLI
    gh
  ];
  
  # SSH server
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  
  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];  # SSH
  };
  
  # System version
  system.stateVersion = "24.05";
  
  # SSH Agent - enables persistent GitHub authentication
  programs.ssh.startAgent = true;
  
  # Git global configuration
  programs.git = {
    enable = true;
    lfs.enable = true;
    config = {
      # Disable GUI password prompts (fixes GitHub auth in TUI)
      core = {
        askpass = "";  # Don't use GUI askpass
      };
      credential = {
        helper = "cache --timeout=86400";  # Cache for 24 hours
      };
    };
  };
  
  # Environment variables to prevent GUI password prompts
  environment.variables = {
    GIT_ASKPASS = lib.mkDefault "";  # Disable GUI askpass
    SSH_ASKPASS = lib.mkDefault "";  # Disable SSH GUI askpass (allow override for desktop)
  };
  
  # Import shell customization modules
  imports = [
    ./shell/homelab-aliases.nix
    ./shell/oh-my-zsh-enhanced.nix
  ];
  
  # Enable enhanced shell environment
  homelab.shell.aliases.enable = true;
  homelab.shell.oh-my-zsh-enhanced.enable = true;
  
  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      hostname = {
        ssh_only = false;
        format = "[$hostname](bold blue) ";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
    };
  };
}
