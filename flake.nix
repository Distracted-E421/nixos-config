{
  description = "Homelab NixOS Configuration - Multi-Machine with Flake-Parts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    flake-parts.url = "github:hercules-ci/flake-parts";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, flake-parts, home-manager, hyprland }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      
      flake = {
        # NixOS Configurations
        nixosConfigurations = {
          # Main Desktop - Obsidian
          obsidian = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { 
              inherit inputs;
              pkgs-unstable = import nixpkgs-unstable {
                system = "x86_64-linux";
                config.allowUnfree = true;
              };
            };
            modules = [
              ./machines/obsidian/hardware-configuration.nix
              ./machines/obsidian/configuration.nix
              
              # Core system modules
              ./modules/common.nix
              ./modules/users/e421.nix
              
              # Desktop environments (enable one at a time or have multiple available)
              ./modules/desktop/hyprland.nix
              ./modules/desktop/kde-plasma.nix
              ./modules/desktop/gnome.nix
              
              # Application modules
              ./modules/apps/media.nix          # Spotify, VLC, media apps
              ./modules/apps/audio-production.nix  # Audacity
              ./modules/apps/torrents.nix       # qBittorrent
              ./modules/apps/gaming.nix         # Steam, gaming tools
              ./modules/apps/development.nix    # Dev tools
              ./modules/apps/browsers.nix       # Firefox, Vivaldi, etc
              ./modules/apps/productivity.nix   # Office, communication
              
              # Hardware specific
              ./modules/hardware/gpu-nvidia.nix
              ./modules/hardware/gpu-intel.nix
              
              # System features
              ./modules/system/boot-menu.nix    # Custom GRUB theme
              ./modules/system/snapshots.nix    # btrfs snapshots with smart naming
            ];
          };
          
          # Test VM (TUI Mode)
          nixos-test = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { 
              inherit inputs;
              pkgs-unstable = import nixpkgs-unstable {
                system = "x86_64-linux";
                config.allowUnfree = true;
              };
            };
            modules = [
              ./machines/nixos-test/hardware-configuration.nix
              ./machines/nixos-test/configuration.nix
              ./modules/common.nix
              ./modules/users/e421.nix
              
              # Desktop environments (disabled in config)
              ./modules/desktop/hyprland.nix
              ./modules/desktop/kde-plasma.nix
              ./modules/desktop/gnome.nix
              
              # Apps
              ./modules/apps/development.nix
              ./modules/apps/media.nix
              ./modules/apps/audio-production.nix
              ./modules/apps/torrents.nix
              ./modules/apps/gaming.nix
              ./modules/apps/browsers.nix
              ./modules/apps/productivity.nix
              
              # Hardware
              ./modules/hardware/vm-guest.nix
              ./modules/hardware/gpu-nvidia.nix
              ./modules/hardware/gpu-intel.nix
              ./modules/hardware/laptop.nix
              
              # System features (TUI enabled in config)
              ./modules/system/boot-menu.nix
              ./modules/system/snapshots.nix
              ./modules/system/tui-status.nix
            ];
          };
          
          # Framework laptop
          framework = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { 
              inherit inputs;
              pkgs-unstable = import nixpkgs-unstable {
                system = "x86_64-linux";
                config.allowUnfree = true;
              };
            };
            modules = [
              ./machines/framework/hardware-configuration.nix
              ./machines/framework/configuration.nix
              ./modules/common.nix
              ./modules/users/e421.nix
              ./modules/desktop/hyprland.nix
              ./modules/apps/development.nix
              ./modules/hardware/laptop.nix
            ];
          };
          
          # Neon laptop
          neon-laptop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { 
              inherit inputs;
              pkgs-unstable = import nixpkgs-unstable {
                system = "x86_64-linux";
                config.allowUnfree = true;
              };
            };
            modules = [
              ./machines/neon-laptop/hardware-configuration.nix
              ./machines/neon-laptop/configuration.nix
              ./modules/common.nix
              ./modules/users/e421.nix
              ./modules/desktop/kde-plasma.nix
              ./modules/apps/development.nix
              ./modules/hardware/laptop.nix
              ./modules/hardware/gpu-intel.nix
            ];
          };
          
          # Pi server
          pi-server = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            specialArgs = { 
              inherit inputs;
              pkgs-unstable = import nixpkgs-unstable {
                system = "aarch64-linux";
                config.allowUnfree = true;
              };
            };
            modules = [
              ./machines/pi-server/hardware-configuration.nix
              ./machines/pi-server/configuration.nix
              ./modules/common.nix
              ./modules/users/e421.nix
              ./modules/services/homelab-server.nix
            ];
          };
        };
      };
      
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system outputs (dev shells, packages, etc.)
        formatter = pkgs.nixpkgs-fmt;
        
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nil
            nixpkgs-fmt
            git
          ];
        };
      };
    };
}
