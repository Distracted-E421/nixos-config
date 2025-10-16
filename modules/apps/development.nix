# Development Tools Module
# Programming languages, IDEs, build tools

{ config, pkgs, pkgs-unstable, lib, ... }:

{
  options = {
    homelab.apps.development.enable = lib.mkEnableOption "development tools";
  };

  config = lib.mkIf config.homelab.apps.development.enable {
    environment.systemPackages = with pkgs; [
      # === TEXT EDITORS & IDEs ===
      # Note: Cursor IDE not yet in nixpkgs, using VSCode instead
      vscode                         # Visual Studio Code
      neovim                         # Modern vim
      helix                          # Modern modal editor
      
      # === VERSION CONTROL ===
      git
      gh                             # GitHub CLI
      tig                            # Text-mode Git interface
      delta                          # Better git diff
      lazygit                        # TUI for git
      
      # === PYTHON ===
      python311Full
      python311Packages.pip
      python311Packages.virtualenv
      poetry                         # Python dependency management (top-level)
      python311Packages.ipython
      python311Packages.black        # Code formatter
      python311Packages.pylint       # Linter
      python311Packages.pytest       # Testing
      ruff                           # Fast Python linter
      
      # === NODE.JS ===
      nodejs_20
      nodePackages.npm
      nodePackages.pnpm
      nodePackages.yarn
      nodePackages.typescript
      nodePackages.eslint
      nodePackages.prettier
      
      # === RUST ===
      rustc
      cargo
      rust-analyzer
      rustfmt
      clippy
      
      # === GO ===
      go
      gopls                          # Go language server
      gotools
      
      # === C/C++ ===
      gcc
      clang
      cmake
      gnumake
      pkg-config
      meson
      ninja
      
      # === BUILD TOOLS ===
      autoconf
      automake
      libtool
      
      # === CONTAINERS & VIRTUALIZATION ===
      docker
      docker-compose
      podman
      kubectl
      k9s                            # Kubernetes TUI
      
      # === DATABASES ===
      postgresql
      sqlite
      redis
      
      # === API TOOLS ===
      postman
      insomnia
      httpie
      
      # === MONITORING & DEBUGGING ===
      gdb
      lldb
      valgrind
      strace
      ltrace
      
      # === DATA TOOLS ===
      jq                             # JSON processor
      yq                             # YAML processor
      
      # === NIX DEVELOPMENT ===
      nil                            # Nix language server
      nixpkgs-fmt                    # Nix formatter
      nix-tree                       # Nix dependency browser
      nix-diff                       # Compare Nix derivations
      
      # === TERMINAL TOOLS ===
      tmux
      screen
      zellij                         # Modern terminal multiplexer
      direnv                         # Environment switcher
      zoxide                         # Smarter cd
    ];
    
    # Docker
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
    
    # Podman (alternative to Docker)
    virtualisation.podman = {
      enable = true;
      dockerCompat = false;          # Don't conflict with Docker
    };
    
    # Libvirt for VMs
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf.enable = true;
        swtpm.enable = true;
      };
    };
    
    # Add virt-manager for VM management GUI
    programs.virt-manager.enable = true;
    
    # Direnv for automatic environment loading
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    
    # Environment variables for development
    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
