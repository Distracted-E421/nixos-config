# Common System Configuration
# Settings shared across all machines

{ config, pkgs, lib, ... }:

{
  imports = [
    ./secrets.nix  # sops-nix secrets management
  ];
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
    GIT_ASKPASS = "";  # Disable GUI askpass
    SSH_ASKPASS = "";  # Disable SSH GUI askpass
  };
  
  # ZSH as default shell with useful aliases
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "docker" "sudo" "history" "gh" ];
      theme = "robbyrussell";
    };
    
    shellAliases = {
      # System management
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos";
      update = "cd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch --flake .";
      cleanup = "sudo nix-collect-garbage -d";
      
      # NixOS rebuild shortcuts
      nrs = "sudo nixos-rebuild switch --flake .";
      nrb = "sudo nixos-rebuild boot --flake .";
      nrt = "sudo nixos-rebuild test --flake .";
      nfu = "nix flake update";
      
      # Navigation
      ll = "eza -lah --icons";
      la = "eza -A --icons";
      l = "eza -lh --icons";
      
      # Homelab navigation
      cdh = "cd /home/e421/homelab";
      cdnix = "cd /home/e421/homelab/devices/Obsidian/config";
      
      # Git shortcuts (with TUI-safe options)
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "GIT_ASKPASS='' git push";  # Force no askpass
      gpl = "GIT_ASKPASS='' git pull";  # Force no askpass
      gl = "git log --oneline --graph";
      gd = "git diff";
      gb = "git branch";
      gco = "git checkout";
      
      # GitHub CLI shortcuts
      ghpr = "gh pr list";
      ghpv = "gh pr view";
      ghpc = "gh pr create";
      ghrl = "gh release list";
      ghst = "gh auth status";
      
      # Homelab git workflow (TUI-safe)
      hpush = "cd /home/e421/homelab && git add -A && git commit -m 'Quick update' && GIT_ASKPASS='' git push origin main";
      hpull = "cd /home/e421/homelab && GIT_ASKPASS='' git pull origin main";
      hsync = "cd /home/e421/homelab && GIT_ASKPASS='' git pull origin main && git add -A && git commit -m 'Sync' && GIT_ASKPASS='' git push origin main";
      
      # Better tools
      cat = "bat";
      grep = "rg";
      find = "fd";
      top = "htop";
    };
    
    # Load SSH keys on shell startup
    loginShellInit = ''
      # Start SSH agent if not running
      if [ -z "$SSH_AUTH_SOCK" ] && command -v ssh-agent &> /dev/null; then
        eval $(ssh-agent -s) > /dev/null 2>&1
      fi
    '';
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
