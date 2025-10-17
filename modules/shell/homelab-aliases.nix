# Homelab Shell Aliases Module
# Comprehensive aliases for all homelab scripts and common tasks

{ config, pkgs, lib, ... }:

{
  options = {
    homelab.shell.aliases.enable = lib.mkEnableOption "homelab shell aliases and functions";
  };

  config = lib.mkIf config.homelab.shell.aliases.enable {
    programs.zsh = {
      shellAliases = {
        # ═══════════════════════════════════════════════════════════
        # SYSTEM MANAGEMENT
        # ═══════════════════════════════════════════════════════════
        
        # NixOS shortcuts
        "rebuild" = "sudo nixos-rebuild switch --flake .";
        "retest" = "sudo nixos-rebuild test --flake .";
        "rebuildboot" = "sudo nixos-rebuild boot --flake .";
        "nixupdate" = "nix flake update && sudo nixos-rebuild switch --flake .";
        "nixclean" = "sudo nix-collect-garbage -d";
        "nixgc" = "sudo nix-collect-garbage --delete-older-than 7d";
        "nixgens" = "nixos-rebuild list-generations";
        "nixrollback" = "sudo nixos-rebuild switch --rollback";
        
        # System monitoring
        "status" = "systemctl status";
        "logs" = "journalctl -u";
        "logsf" = "journalctl -fu";  # Follow logs
        "services" = "systemctl list-units --type=service --state=running";
        "failed" = "systemctl --failed";
        
        # ═══════════════════════════════════════════════════════════
        # NAVIGATION - HOMELAB
        # ═══════════════════════════════════════════════════════════
        
        "cdh" = "cd ~/homelab";
        "cdhome" = "cd ~/homelab";
        "cdnix" = "cd ~/homelab/devices/Obsidian/config";
        "cddevices" = "cd ~/homelab/devices";
        "cdservices" = "cd ~/homelab/services";
        "cddocs" = "cd ~/homelab/docs";
        "cdscripts" = "cd ~/homelab/scripts";
        
        # Device-specific navigation
        "cdframework" = "cd ~/homelab/devices/framework";
        "cdneon" = "cd ~/homelab/devices/neon-laptop";
        "cdobsidian" = "cd ~/homelab/devices/Obsidian";
        "cdpi" = "cd ~/homelab/devices/pi-server";
        
        # Service navigation
        "cdai" = "cd ~/homelab/services/ai-inference";
        "cdk0s" = "cd ~/homelab/services/k0s";
        "cdha" = "cd ~/homelab/homeassistant";
        
        # ═══════════════════════════════════════════════════════════
        # GIT WORKFLOW
        # ═══════════════════════════════════════════════════════════
        
        # Basic git
        "gs" = "git status";
        "ga" = "git add";
        "gaa" = "git add -A";
        "gc" = "git commit";
        "gcm" = "git commit -m";
        "gp" = "GIT_ASKPASS='' git push";
        "gpl" = "GIT_ASKPASS='' git pull";
        "gl" = "git log --oneline --graph --decorate";
        "gll" = "git log --oneline --graph --decorate -10";
        "gd" = "git diff";
        "gds" = "git diff --staged";
        "gb" = "git branch";
        "gco" = "git checkout";
        "gst" = "git stash";
        "gstp" = "git stash pop";
        
        # GitHub CLI
        "ghpr" = "gh pr list";
        "ghpv" = "gh pr view";
        "ghpc" = "gh pr create";
        "ghst" = "gh auth status";
        "ghrl" = "gh release list";
        "ghruns" = "gh run list --limit 10";
        "ghwatch" = "gh run watch";
        
        # Homelab git workflows
        "hpush" = "cd ~/homelab && git add -A && git commit -m 'Quick update' && GIT_ASKPASS='' git push origin main";
        "hpull" = "cd ~/homelab && GIT_ASKPASS='' git pull origin main";
        "hsync" = "cd ~/homelab && GIT_ASKPASS='' git pull origin main && git add -A && git commit -m 'Sync' && GIT_ASKPASS='' git push origin main";
        "hstatus" = "cd ~/homelab && git status";
        
        # ═══════════════════════════════════════════════════════════
        # KUBERNETES / K0S
        # ═══════════════════════════════════════════════════════════
        
        "k" = "sudo /usr/local/bin/k0s kubectl";
        "kgn" = "sudo /usr/local/bin/k0s kubectl get nodes";
        "kgp" = "sudo /usr/local/bin/k0s kubectl get pods -A";
        "kgs" = "sudo /usr/local/bin/k0s kubectl get svc -A";
        "kgd" = "sudo /usr/local/bin/k0s kubectl get deployments -A";
        "kdesc" = "sudo /usr/local/bin/k0s kubectl describe";
        "klogs" = "sudo /usr/local/bin/k0s kubectl logs";
        "kexec" = "sudo /usr/local/bin/k0s kubectl exec -it";
        "kstatus" = "sudo systemctl status k0scontroller";
        "k0slogs" = "sudo journalctl -u k0scontroller -f";
        
        # ═══════════════════════════════════════════════════════════
        # DOCKER
        # ═══════════════════════════════════════════════════════════
        
        "d" = "docker";
        "dps" = "docker ps";
        "dpsa" = "docker ps -a";
        "di" = "docker images";
        "dlog" = "docker logs";
        "dlogf" = "docker logs -f";
        "dexec" = "docker exec -it";
        "dstop" = "docker stop";
        "drm" = "docker rm";
        "drmi" = "docker rmi";
        "dprune" = "docker system prune -af";
        
        # Docker Compose
        "dc" = "docker-compose";
        "dcup" = "docker-compose up -d";
        "dcdown" = "docker-compose down";
        "dclogs" = "docker-compose logs -f";
        "dcrestart" = "docker-compose restart";
        
        # ═══════════════════════════════════════════════════════════
        # SSH / REMOTE
        # ═══════════════════════════════════════════════════════════
        
        "sshframework" = "ssh framework";
        "sshneon" = "ssh neon-laptop";
        "sshpi" = "ssh e421@pi-server";
        "sshevie" = "ssh evie@Evie-Desktop";
        
        # ═══════════════════════════════════════════════════════════
        # FILE OPERATIONS (Better Tools)
        # ═══════════════════════════════════════════════════════════
        
        "cat" = "bat";
        "grep" = "rg";
        "find" = "fd";
        "top" = "htop";
        "ps" = "procs";
        
        # Navigation
        "ll" = "eza -lah --icons --git";
        "la" = "eza -A --icons";
        "l" = "eza -lh --icons --git";
        "tree" = "eza --tree --icons";
        
        # ═══════════════════════════════════════════════════════════
        # PYTHON / VIRTUAL ENVIRONMENTS
        # ═══════════════════════════════════════════════════════════
        
        "py" = "python3";
        "pip" = "pip3";
        "venv" = "python3 -m venv venv";
        "activate" = "source venv/bin/activate";
        "pyserver" = "python3 -m http.server";
        
        # ═══════════════════════════════════════════════════════════
        # NETWORK
        # ═══════════════════════════════════════════════════════════
        
        "myip" = "curl -s ifconfig.me";
        "localip" = "ip -brief addr show | grep UP";
        "ports" = "sudo netstat -tulpn";
        "listening" = "sudo lsof -iTCP -sTCP:LISTEN -P -n";
        
        # ═══════════════════════════════════════════════════════════
        # QUICK EDITS
        # ═══════════════════════════════════════════════════════════
        
        "editnix" = "cd ~/homelab/devices/Obsidian/config && \\$EDITOR";
        "editzsh" = "\\$EDITOR ~/.zshrc";
        "editaliases" = "cd ~/homelab/devices/Obsidian/config/modules/shell && \\$EDITOR homelab-aliases.nix";
        
        # ═══════════════════════════════════════════════════════════
        # UTILITIES
        # ═══════════════════════════════════════════════════════════
        
        "path" = "echo \\$PATH | tr ':' '\\n'";
        "reload" = "source ~/.zshrc";
        "c" = "clear";
        "h" = "history";
        "please" = "sudo";
        "fucking" = "sudo";
      };
      
      # Additional shell functions
      interactiveShellInit = ''
        # ═══════════════════════════════════════════════════════════
        # HOMELAB HELPER FUNCTIONS
        # ═══════════════════════════════════════════════════════════
        
        # Show all available homelab aliases and functions
        aliases() {
          echo "╔════════════════════════════════════════════════════════════════╗"
          echo "║           HOMELAB ALIASES & COMMANDS REFERENCE                 ║"
          echo "╚════════════════════════════════════════════════════════════════╝"
          echo ""
          echo "📦 SYSTEM MANAGEMENT"
          echo "  rebuild          - Rebuild NixOS configuration"
          echo "  retest           - Test NixOS configuration (no boot entry)"
          echo "  nixupdate        - Update flake and rebuild"
          echo "  nixclean         - Clean old generations"
          echo "  nixgens          - List NixOS generations"
          echo "  nixrollback      - Rollback to previous generation"
          echo "  status <service> - Check service status"
          echo "  logs <service>   - View service logs"
          echo "  services         - List running services"
          echo ""
          echo "📂 NAVIGATION"
          echo "  cdh / cdhome     - Go to ~/homelab"
          echo "  cdnix            - Go to NixOS config"
          echo "  cddevices        - Go to devices/"
          echo "  cdservices       - Go to services/"
          echo "  cdframework      - Go to framework device"
          echo "  cdneon           - Go to neon-laptop device"
          echo "  cdai             - Go to AI inference service"
          echo "  cdk0s            - Go to k0s service"
          echo ""
          echo "🔧 GIT WORKFLOW"
          echo "  gs               - Git status"
          echo "  gaa              - Git add all"
          echo "  gcm 'msg'        - Git commit with message"
          echo "  gp               - Git push"
          echo "  hpush            - Quick homelab commit & push"
          echo "  hsync            - Sync homelab (pull + push)"
          echo "  ghwatch          - Watch GitHub Actions runs"
          echo ""
          echo "☸️  KUBERNETES (k0s)"
          echo "  k                - kubectl command"
          echo "  kgn              - Get nodes"
          echo "  kgp              - Get all pods"
          echo "  kgs              - Get all services"
          echo "  kstatus          - Check k0s service status"
          echo ""
          echo "🐳 DOCKER"
          echo "  dps              - List running containers"
          echo "  dlog <container> - View container logs"
          echo "  dexec <cont> sh  - Exec into container"
          echo "  dcup             - Docker compose up"
          echo "  dcdown           - Docker compose down"
          echo ""
          echo "🌐 SSH"
          echo "  sshframework     - SSH to framework"
          echo "  sshneon          - SSH to neon-laptop"
          echo "  sshpi            - SSH to pi-server"
          echo ""
          echo "🛠️  UTILITIES"
          echo "  ll               - Better ls (eza)"
          echo "  cat <file>       - Better cat (bat)"
          echo "  grep <pattern>   - Better grep (ripgrep)"
          echo "  myip             - Show public IP"
          echo "  ports            - Show open ports"
          echo "  reload           - Reload zsh config"
          echo ""
          echo "💡 TIP: Run 'aliases' anytime to see this help!"
          echo ""
        }
        
        # Fuzzy find and cd
        fcd() {
          local dir
          dir=$(find ~/homelab -type d -not -path '*/.*' 2>/dev/null | fzf)
          if [[ -n "$dir" ]]; then
            cd "$dir"
          fi
        }
        
        # Quick homelab commit with automatic message
        hcommit() {
          local msg="$*"
          if [[ -z "$msg" ]]; then
            msg="Update: $(date '+%Y-%m-%d %H:%M')"
          fi
          cd ~/homelab
          git add -A
          git commit -m "$msg"
          GIT_ASKPASS='' git push origin main
          echo "✅ Committed and pushed: $msg"
        }
        
        # Show homelab system status
        hstats() {
          echo "╔════════════════════════════════════════════════════════════════╗"
          echo "║                    HOMELAB SYSTEM STATUS                       ║"
          echo "╚════════════════════════════════════════════════════════════════╝"
          echo ""
          echo "🖥️  SYSTEM INFO"
          hostnamectl | head -5
          echo ""
          echo "💾 DISK USAGE"
          df -h / | tail -1
          echo ""
          echo "🧠 MEMORY"
          free -h | grep Mem
          echo ""
          echo "⚙️  SERVICES"
          systemctl list-units --type=service --state=running | grep -E 'k0s|docker|ssh' || echo "  No key services running"
          echo ""
        }
        
        # Quick deploy nixos config to another machine
        deploy-to() {
          local machine="$1"
          if [[ -z "$machine" ]]; then
            echo "Usage: deploy-to <framework|neon|pi>"
            return 1
          fi
          
          echo "📤 Deploying NixOS config to $machine..."
          cd ~/homelab
          git add -A && git commit -m "Deploy to $machine" && git push origin main
          ssh "$machine" "cd ~/nixos-config && git pull origin main && sudo nixos-rebuild switch --flake .#$machine"
        }
        
        # Show what's new in homelab repo
        whats-new() {
          cd ~/homelab
          echo "📋 Recent changes in homelab:"
          git log --oneline --decorate -10
        }
      '';
    };
  };
}
