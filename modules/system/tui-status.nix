# TUI Status Display Module
# Terminal-based status dashboard for headless/server deployments
# Perfect for Framework laptop server setup

{ config, pkgs, lib, ... }:

{
  options = {
    homelab.system.tui-status.enable = lib.mkEnableOption "TUI status display system";
  };

  config = lib.mkIf config.homelab.system.tui-status.enable {
    
    # === TUI DASHBOARD TOOLS ===
    environment.systemPackages = with pkgs; [
      # System monitoring TUIs
      btop              # Modern resource monitor (better than htop)
      htop              # Classic process viewer
      iotop             # I/O monitoring
      nethogs           # Network bandwidth per process
      iftop             # Network interface monitoring
      bmon              # Bandwidth monitor with graph
      
      # System information
      neofetch          # System info with ASCII art
      fastfetch         # Faster alternative to neofetch
      inxi              # Detailed system information
      lm_sensors        # Hardware sensor monitoring
      
      # Service status
      systemctl-tui     # Interactive systemd service manager
      
      # Network status
      speedtest-cli     # Network speed testing
      
      # Container/cluster status
      k9s               # Kubernetes TUI (if using k3s)
      lazydocker        # Docker TUI
      
      # File manager - RANGER (the best one!)
      ranger            # File manager with vim keybindings
      
      # Ranger dependencies for syntax highlighting and previews
      python311Packages.pygments  # Syntax highlighting in ranger
      highlight         # Alternative syntax highlighter
      mediainfo         # Media file information
      poppler_utils     # PDF preview (pdftotext)
      atool             # Archive preview
      w3m               # HTML preview
      lynx              # Alternative HTML preview
      pandoc            # Markdown to text conversion
      
      # Neovim - modern vim with better defaults
      neovim            # The one true editor
      
      # Custom dashboards
      tmux              # Terminal multiplexer for persistent sessions
      screen            # Alternative multiplexer
      
      # Interactive tools
      fzf               # Fuzzy finder
      ripgrep           # Fast grep alternative
    ];
    
    # === RANGER CONFIGURATION ===
    # Enable syntax highlighting and rich previews
    environment.etc."ranger/rc.conf".text = ''
      # File preview settings
      set preview_files true
      set preview_directories true
      set preview_images false  # Requires specific terminal support
      
      # Syntax highlighting
      set use_preview_script true
      set preview_script ~/.config/ranger/scope.sh
      
      # Show hidden files
      set show_hidden false
      set show_hidden_bookmarks true
      
      # VCS integration
      set vcs_aware true
      
      # Border and padding
      set draw_borders both
      set padding_right true
      
      # Mouse support
      set mouse_enabled true
      
      # Line numbers
      set line_numbers relative
      
      # Colorscheme
      set colorscheme default
      
      # Automatically load ranger config on start
      set automatically_count_files true
      
      # Preview images method (works in some terminals)
      set preview_images_method w3m
      
      # Open files with rifle
      set open_all_images false
    '';
    
    # Ranger scope script for file previews
    environment.etc."ranger/scope.sh" = {
      source = pkgs.writeScript "scope.sh" ''
        #!/bin/sh
        # Ranger file preview script with syntax highlighting
        
        set -o noclobber -o noglob -o nounset -o pipefail
        IFS=$'\n'
        
        FILE_PATH="$1"
        PV_WIDTH="$2"
        PV_HEIGHT="$3"
        IMAGE_CACHE_PATH="$4"
        PV_IMAGE_ENABLED="$5"
        
        FILE_EXTENSION="''${FILE_PATH##*.}"
        FILE_EXTENSION_LOWER="$(printf "%s" "''${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"
        MIMETYPE="$(file --dereference --brief --mime-type -- "''${FILE_PATH}")"
        
        # Markdown preview
        if [[ "''${FILE_EXTENSION_LOWER}" =~ ^(md|markdown)$ ]]; then
          ${pkgs.pandoc}/bin/pandoc -s -t plain "''${FILE_PATH}" && exit 5
          exit 1
        fi
        
        # Syntax highlighting for code
        case "''${MIMETYPE}" in
          text/* | */xml | application/json | application/x-yaml)
            ${pkgs.python311Packages.pygments}/bin/pygmentize -f terminal256 -O style=monokai -g "''${FILE_PATH}" && exit 5
            ${pkgs.highlight}/bin/highlight --out-format=ansi --force "''${FILE_PATH}" && exit 5
            cat "''${FILE_PATH}" && exit 5
            exit 1
            ;;
        esac
        
        # Archive preview
        case "''${MIMETYPE}" in
          application/*zip | application/x-rar | application/x-tar | application/x-7z*)
            ${pkgs.atool}/bin/atool --list -- "''${FILE_PATH}" && exit 5
            exit 1
            ;;
        esac
        
        # PDF preview
        if [ "''${MIMETYPE}" = "application/pdf" ]; then
          ${pkgs.poppler_utils}/bin/pdftotext -l 10 -nopgbrk -q -- "''${FILE_PATH}" - && exit 5
          exit 1
        fi
        
        # Media info
        case "''${MIMETYPE}" in
          video/* | audio/*)
            ${pkgs.mediainfo}/bin/mediainfo "''${FILE_PATH}" && exit 5
            exit 1
            ;;
        esac
        
        # Fallback to cat
        cat "''${FILE_PATH}"
      '';
      mode = "0755";
    };
    
    # === NEOVIM CONFIGURATION ===
    # Starter configuration with good defaults
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      
      configure = {
        customRC = ''
          " === BASIC SETTINGS ===
          set number relativenumber  " Hybrid line numbers
          set mouse=a                " Enable mouse support
          set clipboard=unnamedplus  " System clipboard integration
          set ignorecase smartcase   " Smart case-insensitive search
          set incsearch hlsearch     " Incremental search with highlighting
          set expandtab              " Use spaces instead of tabs
          set tabstop=2 shiftwidth=2 " 2 space indentation
          set autoindent smartindent " Auto indent
          set wrap linebreak         " Wrap lines at word boundaries
          set scrolloff=8            " Keep 8 lines visible when scrolling
          set signcolumn=yes         " Always show sign column
          set updatetime=300         " Faster completion
          set timeoutlen=500         " Faster key sequences
          set termguicolors          " True color support
          
          " === CURSOR SETTINGS - BLINKING I-BEAM ===
          set guicursor=n-v-c:block,i-ci-ve:ver25-blinkwait700-blinkoff400-blinkon250,r-cr:hor20,o:hor50
          
          " === KEYBINDINGS ===
          " Set leader key to space
          let mapleader = " "
          
          " Quick save and quit
          nnoremap <leader>w :w<CR>
          nnoremap <leader>q :q<CR>
          nnoremap <leader>x :x<CR>
          
          " Split navigation
          nnoremap <C-h> <C-w>h
          nnoremap <C-j> <C-w>j
          nnoremap <C-k> <C-w>k
          nnoremap <C-l> <C-w>l
          
          " Clear search highlighting
          nnoremap <leader>/ :noh<CR>
          
          " File explorer
          nnoremap <leader>e :Explore<CR>
          
          " === VISUAL SETTINGS ===
          syntax enable
          colorscheme default
          set background=dark
          
          " Show matching brackets
          set showmatch
          
          " Highlight current line
          set cursorline
          
          " === STATUS LINE ===
          set laststatus=2
          set statusline=%f\ %m%r%h%w\ [%{&ff}]\ %y\ [%p%%]\ [%l,%c]
        '';
      };
    };
    
    # === TMUX CONFIGURATION WITH MOUSE SUPPORT ===
    programs.tmux = {
      enable = true;
      terminal = "screen-256color";
      historyLimit = 10000;
      keyMode = "vi";
      customPaneNavigationAndResize = true;
      
      extraConfig = ''
        # Mouse support (enabled here, not as module option)
        set -g mouse on
        
        # Cursor settings - blinking I-beam for insert mode
        # Fix underscore cursor to be I-beam pipe
        set -g -a terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'
        set -g -a terminal-overrides ',*:Cs=\E]12;%p1%s\007:Cr=\E]112\007'
        
        # Better colors
        set -g default-terminal "screen-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        
        # Vi mode
        setw -g mode-keys vi
        
        # Start windows and panes at 1, not 0
        set -g base-index 1
        setw -g pane-base-index 1
        
        # Renumber windows when one is closed
        set -g renumber-windows on
        
        # Status bar
        set -g status-style 'bg=#1e1e2e fg=#cdd6f4'
        set -g status-left '#[bg=#89b4fa,fg=#1e1e2e,bold] #{host_short} '
        set -g status-right '#[bg=#f38ba8,fg=#1e1e2e,bold] %Y-%m-%d %H:%M '
        
        # Window status
        setw -g window-status-current-style 'bg=#89dceb fg=#1e1e2e bold'
        setw -g window-status-current-format ' #I:#W '
        setw -g window-status-style 'bg=#313244 fg=#cdd6f4'
        setw -g window-status-format ' #I:#W '
        
        # Pane borders
        set -g pane-border-style 'fg=#313244'
        set -g pane-active-border-style 'fg=#89b4fa'
        
        # Better split bindings
        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %
        
        # Reload config
        bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
      '';
    };
    
    # === SYSTEMD SERVICE FOR STATUS DISPLAY ===
    # Auto-start status dashboard on login
    systemd.user.services.tui-dashboard = {
      description = "Homelab TUI Status Dashboard";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.tmux}/bin/tmux new-session -d -s homelab-status '${pkgs.btop}/bin/btop'";
        Restart = "on-failure";
      };
    };
    
    # === CUSTOM MOTD (Message of the Day) ===
    # Show system status on SSH login
    environment.etc."motd".text = ''
      
      ╔════════════════════════════════════════════════════════════╗
      ║         HOMELAB STATUS - TUI Dashboard Ready              ║
      ║              🖱️  Mouse Support | 📁 Ranger | ✏️  Neovim     ║
      ╚════════════════════════════════════════════════════════════╝
      
      Quick Commands:
        btop          - System resource monitor (mouse-enabled)
        htop          - Process viewer
        systemctl-tui - Service manager (interactive)
        k9s           - Kubernetes dashboard (if k3s running)
        lazydocker    - Docker container manager (mouse-enabled)
        
        ranger        - File manager (syntax highlighting + markdown preview)
        nvim          - Neovim text editor (with blinking I-beam cursor)
        
        tmux attach -t homelab-status  - Attach to status dashboard
        
      System Info:
        fastfetch     - Quick system overview
        inxi -Fxz     - Detailed hardware info
        sensors       - Hardware temperature/voltage
      
      Ranger Features:
        🎨 Syntax highlighting for code files
        📄 Markdown preview (rendered as text)
        📦 Archive listing (zip, tar, etc)
        📊 Media file information
        🖱️  Mouse support enabled
      
      Neovim Quick Start:
        nvim filename.txt      - Open file
        Press 'i' for INSERT mode (start typing)
        Press ESC to go back to NORMAL mode
        Type :w to save, :q to quit, :wq to save & quit
        Space key is <leader> for shortcuts
        
      Learn Neovim:
        vimtutor               - Interactive vim tutorial (30min)
        https://neovim.io/doc/user/quickref.html
    '';
    
    # === SHELL ALIASES FOR QUICK STATUS ===
    programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
      status = "btop";
      mon = "btop";
      dashboard = "tmux attach -t homelab-status || tmux new-session -s homelab-status btop";
      services = "systemctl-tui";
      k8s = "k9s";
      docker-tui = "lazydocker";
      
      # Ranger is THE file manager
      files = "ranger";
      r = "ranger";
      
      # Neovim shortcuts
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      edit = "nvim";
    };
    
    programs.bash.shellAliases = {
      status = "btop";
      mon = "btop";
      dashboard = "tmux attach -t homelab-status || tmux new-session -s homelab-status btop";
      services = "systemctl-tui";
      k8s = "k9s";
      docker-tui = "lazydocker";
      
      # Ranger is THE file manager
      files = "ranger";
      r = "ranger";
      
      # Neovim shortcuts
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      edit = "nvim";
    };
    
    # === AUTO-START TMUX SESSION ON LOGIN ===
    # Automatically attach to dashboard on SSH login
    programs.zsh.loginShellInit = lib.mkIf config.programs.zsh.enable ''
      # Auto-attach to homelab status dashboard if SSH session
      if [[ -n "$SSH_CONNECTION" ]] && [[ -z "$TMUX" ]]; then
        echo "🖱️  Mouse support | 📁 Ranger (syntax highlight) | ✏️  Neovim ready"
        echo ""
        tmux attach-session -t homelab-status || tmux new-session -s homelab-status btop
      fi
    '';
    
    programs.bash.loginShellInit = ''
      # Auto-attach to homelab status dashboard if SSH session
      if [[ -n "$SSH_CONNECTION" ]] && [[ -z "$TMUX" ]]; then
        echo "🖱️  Mouse support | 📁 Ranger (syntax highlight) | ✏️  Neovim ready"
        echo ""
        tmux attach-session -t homelab-status || tmux new-session -s homelab-status btop
      fi
    '';
    
    # === SENSOR MONITORING ===
    # lm_sensors included in systemPackages above
    # Additional hardware monitoring can be enabled per-machine
    
    # === OPTIONAL: SERIAL CONSOLE ===
    # Enable serial console for remote access without network
    # boot.kernelParams = [ "console=ttyS0,115200" "console=tty1" ];
    # systemd.services."serial-getty@ttyS0".enable = true;
  };
}
