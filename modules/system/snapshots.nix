# Snapshots Module
# Intelligent system snapshots with human-readable naming

{ config, pkgs, lib, ... }:

{
  options = {
    homelab.system.snapshots.enable = lib.mkEnableOption "system snapshots";
  };

  config = lib.mkIf config.homelab.system.snapshots.enable {
    
    # Snapper for automatic btrfs snapshots
    services.snapper = {
      configs = {
        home = {
          SUBVOLUME = "/home";
          ALLOW_USERS = [ "e421" ];
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
          
          # Snapshot schedule
          TIMELINE_MIN_AGE = "1800";
          TIMELINE_LIMIT_HOURLY = "10";
          TIMELINE_LIMIT_DAILY = "7";
          TIMELINE_LIMIT_WEEKLY = "4";
          TIMELINE_LIMIT_MONTHLY = "6";
          TIMELINE_LIMIT_YEARLY = "2";
        };
        
        root = {
          SUBVOLUME = "/";
          ALLOW_USERS = [ "e421" ];
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
          
          TIMELINE_MIN_AGE = "1800";
          TIMELINE_LIMIT_HOURLY = "5";
          TIMELINE_LIMIT_DAILY = "7";
          TIMELINE_LIMIT_WEEKLY = "4";
          TIMELINE_LIMIT_MONTHLY = "3";
        };
      };
      
      # Automatic snapshots before system changes
      snapshotRootOnBoot = true;
    };
    
    # Btrbk for backup and replication
    services.btrbk = {
      instances = {
        "homelab-backup" = {
          onCalendar = "daily";
          settings = {
            timestamp_format = "long-iso";
            snapshot_preserve_min = "7d";
            snapshot_preserve = "7d 4w 6m";
            
            volume = {
              "/home" = {
                snapshot_dir = ".snapshots";
                subvolume = {
                  "e421" = { };
                };
              };
            };
          };
        };
      };
    };
    
    # Install snapshot management tools
    environment.systemPackages = with pkgs; [
      snapper
      snapper-gui            # GUI for snapshot management
      btrfs-progs            # btrfs tools
      
      # Custom script for snapshot naming
      (writeScriptBin "list-snapshots" ''
        #!/usr/bin/env bash
        # List snapshots with human-readable format
        
        echo "═══════════════════════════════════════════════════════"
        echo " SYSTEM SNAPSHOTS - Organized by Date"
        echo "═══════════════════════════════════════════════════════"
        echo ""
        
        snapper -c root list | tail -n +3 | while read -r line; do
          num=$(echo "$line" | awk '{print $1}')
          date=$(echo "$line" | awk '{print $3, $4}')
          desc=$(echo "$line" | awk '{$1=$2=$3=$4=""; print $0}' | sed 's/^  *//')
          
          # Parse date and add day separator
          day=$(echo "$date" | cut -d' ' -f1)
          if [ "$day" != "$prev_day" ]; then
            echo ""
            echo "────────────────────────────────────────────────────"
            echo " 📅 $day"
            echo "────────────────────────────────────────────────────"
            prev_day="$day"
          fi
          
          # Show snapshot with icon
          echo "  🔵 Snapshot $num - $date - $desc"
        done
        
        echo ""
        echo "═══════════════════════════════════════════════════════"
      '')
      
      # Script to create named snapshots
      (writeScriptBin "create-snapshot" ''
        #!/usr/bin/env bash
        # Create a named snapshot with description
        
        if [ -z "$1" ]; then
          echo "Usage: create-snapshot <description>"
          echo "Example: create-snapshot 'Before system upgrade'"
          exit 1
        fi
        
        DESC="$1"
        DATE=$(date '+%Y-%m-%d %H:%M:%S')
        
        echo "Creating snapshot: $DESC"
        snapper -c root create --description "$DESC ($DATE)" --cleanup-algorithm timeline
        echo "✓ Snapshot created successfully"
        
        echo ""
        echo "Recent snapshots:"
        snapper -c root list | tail -5
      '')
      
      # Script to update GRUB with snapshot entries
      (writeScriptBin "update-grub-snapshots" ''
        #!/usr/bin/env bash
        # Update GRUB with snapshot boot entries
        
        echo "Generating GRUB entries for btrfs snapshots..."
        
        # This will be automatically detected by GRUB
        ${pkgs.snapper}/bin/snapper -c root list --columns number,date,description | \
          tail -n +3 | sort -rn | head -20 | while read -r num date time desc; do
          
          # Format: "2025-10-15 14:30 - Description"
          label="$date $time - $desc"
          echo "  → $label"
        done
        
        echo "✓ Run 'sudo nixos-rebuild boot' to update GRUB menu"
      '')
    ];
    
    # Automatic snapshot before NixOS rebuild
    system.activationScripts.snapshotBeforeRebuild = lib.stringAfter [ "etc" ] ''
      echo "Creating pre-rebuild snapshot..."
      ${pkgs.snapper}/bin/snapper -c root create \
        --description "Before NixOS rebuild - $(date '+%Y-%m-%d %H:%M:%S')" \
        --cleanup-algorithm number || true
    '';
  };
}
