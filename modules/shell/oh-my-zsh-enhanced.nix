# Enhanced Oh-My-ZSH Configuration Module
# Comprehensive ZSH environment with plugins, themes, and customizations

{ config, pkgs, lib, ... }:

{
  options = {
    homelab.shell.oh-my-zsh-enhanced.enable = lib.mkEnableOption "enhanced oh-my-zsh configuration";
  };

  config = lib.mkIf config.homelab.shell.oh-my-zsh-enhanced.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      
      # History configuration
      histSize = 100000;
      histFile = "$HOME/.zsh_history";
      setOptions = [
        "EXTENDED_HISTORY"       # Write the history file in extended format
        "SHARE_HISTORY"          # Share history between all sessions
        "HIST_IGNORE_DUPS"       # Don't record duplicate entries
        "HIST_IGNORE_SPACE"      # Don't record entries starting with space
        "HIST_SAVE_NO_DUPS"      # Don't write duplicate entries
        "HIST_VERIFY"            # Show command before executing from history
        "HIST_REDUCE_BLANKS"     # Remove superfluous blanks
        "HIST_FIND_NO_DUPS"      # Don't show duplicates in search
      ];
      
      # Oh-My-ZSH configuration
      ohMyZsh = {
        enable = true;
        
        # ═══════════════════════════════════════════════════════════
        # PLUGINS - Comprehensive set for homelab development
        # ═══════════════════════════════════════════════════════════
        plugins = [
          # Core productivity
          "git"              # Git shortcuts and info
          "gh"               # GitHub CLI completion
          "sudo"             # Press ESC twice for sudo
          "history"          # History shortcuts
          "command-not-found" # Suggest package for missing commands
          
          # Development
          "docker"           # Docker completion
          "docker-compose"   # Docker Compose completion
          "kubectl"          # Kubernetes completion
          "python"           # Python shortcuts
          "pip"              # Python pip completion
          "rust"             # Rust/Cargo completion
          "golang"           # Go completion
          "npm"              # Node.js npm completion
          
          # System tools
          "systemd"          # Systemd shortcuts
          "ssh"              # SSH completion
          "rsync"            # Rsync completion
          "tmux"             # Tmux integration
          "screen"           # Screen integration
          
          # File operations
          "extract"          # Extract any archive with 'extract'
          "copyfile"         # Copy file contents to clipboard
          "copypath"         # Copy current path to clipboard
          "copybuffer"       # Copy terminal buffer
          
          # Navigation
          "z"                # Jump to frequently used directories
          "dirhistory"       # Navigate directory history (Alt+arrows)
          "last-working-dir" # Start in last directory
          
          # Utilities
          "colored-man-pages" # Colorful man pages
          "colorize"         # Syntax highlighting for cat
          "encode64"         # Base64 encoding/decoding
          "urltools"         # URL manipulation tools
          "web-search"       # Search from terminal (google, ddg, etc.)
          
          # NixOS specific
          "nix-shell"        # Nix-shell integration
        ];
        
        # ═══════════════════════════════════════════════════════════
        # THEME CONFIGURATION
        # ═══════════════════════════════════════════════════════════
        # Popular themes you can switch between:
        # - robbyrussell (default, minimal)
        # - agnoster (powerline, needs nerd font)
        # - powerlevel10k (advanced, needs setup)
        # - af-magic (colorful with git info)
        # - jonathan (clean, two-line)
        # - bira (informative)
        # - ys (compact, informative)
        
        theme = "af-magic";  # Colorful and informative
      };
      
      # ═══════════════════════════════════════════════════════════
      # SHELL INITIALIZATION
      # ═══════════════════════════════════════════════════════════
      interactiveShellInit = ''
        # ═══════════════════════════════════════════════════════════
        # ZSH OPTIONS
        # ═══════════════════════════════════════════════════════════
        
        # Navigation
        setopt AUTO_CD              # Just type directory name to cd
        setopt AUTO_PUSHD           # Push old directory onto stack
        setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
        setopt PUSHD_SILENT         # Don't print directory stack
        
        # Completion
        setopt COMPLETE_IN_WORD     # Complete from both ends of word
        setopt ALWAYS_TO_END        # Move cursor after completion
        setopt AUTO_MENU            # Show menu on tab
        setopt AUTO_LIST            # List choices on ambiguous completion
        setopt COMPLETE_ALIASES     # Complete aliases
        
        # Correction
        setopt CORRECT              # Correct commands
        setopt CORRECT_ALL          # Correct all arguments
        
        # Job control
        setopt AUTO_CONTINUE        # Disown jobs on exit
        setopt NOTIFY               # Report status of background jobs immediately
        setopt LONG_LIST_JOBS       # List jobs in long format
        
        # ═══════════════════════════════════════════════════════════
        # COMPLETION STYLING
        # ═══════════════════════════════════════════════════════════
        
        # Use menu selection for completion
        zstyle ':completion:*' menu select
        
        # Cache completions
        zstyle ':completion:*' use-cache yes
        zstyle ':completion:*' cache-path ~/.zsh/cache
        
        # Case-insensitive completion
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
        
        # Colorful completion
        zstyle ':completion:*' list-colors "''${(@s.:.)LS_COLORS}"
        
        # Group completion by type
        zstyle ':completion:*' group-name '''
        zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
        zstyle ':completion:*:warnings' format '%F{red}No matches found%f'
        
        # Better kill completion
        zstyle ':completion:*:*:kill:*' menu yes select
        zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
        
        # SSH/SCP hostname completion
        zstyle ':completion:*:(ssh|scp):*' hosts $(grep -E '^Host ' ~/.ssh/config 2>/dev/null | awk '{print $2}')
        
        # ═══════════════════════════════════════════════════════════
        # KEY BINDINGS
        # ═══════════════════════════════════════════════════════════
        
        # Use Emacs key bindings (can change to vi with `bindkey -v`)
        bindkey -e
        
        # Better history search with Up/Down
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
        
        # Ctrl+Arrow to move between words
        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word
        
        # Ctrl+Delete/Backspace to delete words
        bindkey '^[[3;5~' kill-word
        bindkey '^H' backward-kill-word
        
        # Home/End keys
        bindkey '^[[H' beginning-of-line
        bindkey '^[[F' end-of-line
        
        # ═══════════════════════════════════════════════════════════
        # ENVIRONMENT VARIABLES
        # ═══════════════════════════════════════════════════════════
        
        # Editor preference
        export EDITOR="nano"
        export VISUAL="nano"
        
        # Pager
        export PAGER="less"
        export LESS="-R"  # Raw control characters for colors
        
        # Better ls colors
        export LS_COLORS="di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33:cd=1;33:su=0;41:sg=0;46:tw=0;42:ow=0;43"
        
        # FZF configuration
        export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info"
        export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        
        # ═══════════════════════════════════════════════════════════
        # HOMELAB-SPECIFIC ENVIRONMENT
        # ═══════════════════════════════════════════════════════════
        
        export HOMELAB_ROOT="$HOME/homelab"
        export NIXOS_CONFIG="$HOME/homelab/devices/Obsidian/config"
        
        # ═══════════════════════════════════════════════════════════
        # WELCOME MESSAGE
        # ═══════════════════════════════════════════════════════════
        
        # Show welcome message on new shell
        if [[ -o interactive ]]; then
          echo "╔════════════════════════════════════════════════════════════════╗"
          echo "║  Welcome to $(hostname) Homelab Shell  "
          echo "╚════════════════════════════════════════════════════════════════╝"
          echo ""
          echo "💡 Quick Tips:"
          echo "   • Type 'aliases' to see all available commands"
          echo "   • Type 'hstats' for system status"
          echo "   • Use 'cdh' to go to homelab directory"
          echo "   • Use 'fcd' for fuzzy directory search"
          echo ""
        fi
      '';
      
      # ═══════════════════════════════════════════════════════════
      # LOGIN SHELL INIT
      # ═══════════════════════════════════════════════════════════
      loginShellInit = ''
        # Start SSH agent if not running
        if [ -z "$SSH_AUTH_SOCK" ] && command -v ssh-agent &> /dev/null; then
          eval $(ssh-agent -s) > /dev/null 2>&1
        fi
        
        # Load any machine-specific configuration
        if [ -f "$HOME/.zshrc.local" ]; then
          source "$HOME/.zshrc.local"
        fi
      '';
    };
    
    # ═══════════════════════════════════════════════════════════
    # ADDITIONAL PACKAGES FOR SHELL EXPERIENCE
    # ═══════════════════════════════════════════════════════════
    environment.systemPackages = with pkgs; [
      # Better CLI tools (already included via aliases)
      procs          # Better ps
      
      # ZSH plugins (manual)
      zsh-history-substring-search
      nix-zsh-completions
      
      # Utilities that enhance shell experience
      thefuck        # Correct previous command by typing 'fuck'
      tldr           # Simplified man pages
      cheat          # Cheatsheets for commands
    ];
  };
}
