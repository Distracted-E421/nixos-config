# Custom Boot Menu Module
# Beautiful GRUB theme with larger fonts and smart organization

{ config, pkgs, lib, ... }:

{
  options = {
    homelab.system.boot-menu.enable = lib.mkEnableOption "custom boot menu configuration";
  };

  config = lib.mkIf config.homelab.system.boot-menu.enable {
    
    boot.loader = {
      timeout = 30;  # Give more time to choose
      
      grub = {
        enable = true;
        device = "nodev";  # For UEFI systems
        efiSupport = true;
        useOSProber = true;  # Detect other operating systems
        
        # Custom resolution for better readability
        gfxmodeEfi = "1920x1080";
        gfxmodeBios = "1920x1080";
        
        # Larger font for better readability
        fontSize = 24;
        
        # Custom theme with modern look
        theme = pkgs.stdenv.mkDerivation {
          name = "homelab-grub-theme";
          src = pkgs.fetchFromGitHub {
            owner = "vinceliuice";
            repo = "grub2-themes";
            rev = "2023-03-18";
            sha256 = "sha256-GLU+BqFpPLGLtZXr0rr8rS+jnAqMJEyyrZlZK8FqrTk=";
          };
          
          installPhase = ''
            mkdir -p $out
            cp -r themes/tela/* $out/
            # Increase font size in theme
            sed -i 's/item_font = ".*"/item_font = "Sans Regular 24"/' $out/theme.txt
            sed -i 's/title-font:.*$/title-font: "Sans Bold 32"/' $out/theme.txt
          '';
        };
        
        # Custom menu entries with better naming
        extraEntries = ''
          # Custom separator for readability
          menuentry "──────────────────────────────────" {
            true
          }
        '';
        
        # GRUB configuration tweaks
        extraConfig = ''
          # Set colors for better visibility
          set color_normal=white/black
          set color_highlight=black/light-gray
          
          # Custom timeout message
          set timeout_style=menu
          
          # Show full kernel version and date in menu
          GRUB_DISABLE_SUBMENU=y
        '';
      };
      
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    
    # Install packages for custom boot menu
    environment.systemPackages = with pkgs; [
      grub2
      os-prober
    ];
    
    # NixOS generation naming with timestamps
    # This makes boot menu entries more readable
    system.nixos.label = "${config.system.nixos.version}-${toString (builtins.substring 0 10 config.system.nixos.revision or "unknown")}";
    
    # Keep more generations for better boot menu organization
    boot.loader.grub.configurationLimit = 50;
    
    # Script to organize boot entries by date
    environment.etc."grub.d/10_linux_custom".source = pkgs.writeScript "10_linux_custom" ''
      #!/bin/sh
      # This script will be executed by GRUB to generate custom boot entries
      # organized by date
      
      exec tail -n +3 $0
      
      # Get all generations and organize by date
      ${pkgs.gnused}/bin/sed 's/generation-//g' | \
      ${pkgs.coreutils}/bin/sort -rn | \
      ${pkgs.gawk}/bin/awk '{
        # Parse date from generation number
        # Format: YYYY-MM-DD HH:MM - Generation X
        print "menuentry \"NixOS - "$0"\" {"
        print "  linux /boot/kernels/"$0
        print "  initrd /boot/initrd-"$0
        print "}"
      }'
    '';
  };
}
